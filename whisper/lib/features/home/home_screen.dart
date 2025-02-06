import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:whisper/data/models/user_model.dart';
import 'package:whisper/providers/user_provider.dart';
import 'package:whisper/features/content/providers/content_provider.dart';
import 'package:whisper/data/models/content_model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final contentAsync = ref.watch(contentFeedProvider);

    return Scaffold(
      appBar: AppBar(
        title: userAsync.when(
          data: (user) {
            final name = user?.displayName.isNotEmpty == true
                ? user!.displayName
                : 'Whisper';
            return Text('Hello, $name');
          },
          loading: () => const Text('Whisper'),
          error: (err, stack) => const Text('Whisper'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => _showNotifications(context),
          ),
          _UserAvatar(userAsync: userAsync),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(contentFeedProvider.future),
        child: CustomScrollView(
          slivers: [
            _TierBadge(userAsync: userAsync),
            const SliverPadding(padding: EdgeInsets.only(top: 16)),
            contentAsync.when(
              loading: () => const _LoadingContent(),
              error: (err, stack) => SliverFillRemaining(
                child: Center(child: Text('Error: $err')),
              ),
              data: (contentList) => _ContentFeed(contentList: contentList),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    // Notification implementation
  }
}

// Added SubscriptionScreen widget to fix compile error
class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription'),
      ),
      body: const Center(
        child: Text('Subscription details will be shown here.'),
      ),
    );
  }
}

class _UserAvatar extends ConsumerWidget {
  const _UserAvatar({required this.userAsync});

  final AsyncValue<AppUser?> userAsync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return userAsync.when(
      data: (user) {
        if (user != null && user.profileImageUrl != null) {
          return CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(user.profileImageUrl!),
          );
        } else {
          // When no image, display initials from displayName
          String initials = '';
          if (user != null && user.displayName.isNotEmpty) {
            final names = user.displayName.split(' ');
            initials = names.length >= 2
                ? '${names.first.characters.first}${names.last.characters.first}'
                : user.displayName.characters.take(2).toString();
          }
          return CircleAvatar(
            child: Text(initials.isNotEmpty ? initials : 'U'),
          );
        }
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => const Icon(Icons.error),
    );
  }
}

class _TierBadge extends StatelessWidget {
  final AsyncValue<AppUser?> userAsync;

  const _TierBadge({required this.userAsync});

  @override
  Widget build(BuildContext context) {
    return userAsync.when(
      data: (user) => SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: _getTierColor(user?.currentTier),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_getTierIcon(user?.currentTier), size: 16),
              const SizedBox(width: 8),
              Text(
                _getTierName(user?.currentTier),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ],
          ),
        ),
      ),
      loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
      error: (error, stack) =>
          const SliverToBoxAdapter(child: SizedBox.shrink()),
    );
  }

  Color _getTierColor(SubscriptionTier? tier) {
    return tier == SubscriptionTier.innerCircle
        ? Colors.amber
        : tier == SubscriptionTier.backstagePass
            ? Colors.purple
            : Colors.blueGrey;
  }

  IconData _getTierIcon(SubscriptionTier? tier) {
    return tier == SubscriptionTier.innerCircle
        ? Icons.stars
        : tier == SubscriptionTier.backstagePass
            ? Icons.vpn_key
            : Icons.public;
  }

  String _getTierName(SubscriptionTier? tier) {
    return tier?.name.split('.').last ?? 'General Access';
  }
}

class _ContentFeed extends StatelessWidget {
  final List<SecretContent> contentList;

  const _ContentFeed({required this.contentList});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => _ContentCard(content: contentList[index]),
        childCount: contentList.length,
      ),
    );
  }
}

// Adding the ContentDetailScreen widget definition to fix the compile error.
class ContentDetailScreen extends StatelessWidget {
  final SecretContent content;

  const ContentDetailScreen({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Content Detail'),
      ),
      body: Center(
        child: Text('Detail view for the content with type: ${content.type}'),
      ),
    );
  }
}

class _ContentCard extends ConsumerWidget {
  final SecretContent content;

  const _ContentCard({required this.content});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).value;
    final currentTier = user?.currentTier ?? SubscriptionTier.generalAdmission;
    final hasAccess = content.tierAccess[currentTier] ?? false;

    return Card(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () => _handleContentTap(context, ref, hasAccess),
        child: Stack(
          children: [
            _ContentPreview(content: content),
            if (!hasAccess) _TierLockOverlay(content: content),
          ],
        ),
      ),
    );
  }

  void _handleContentTap(BuildContext context, WidgetRef ref, bool hasAccess) {
    if (!hasAccess) {
      showDialog(
        context: context,
        builder: (context) => UpgradePromptDialog(content: content),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ContentDetailScreen(content: content),
        ),
      );
    }
  }
}

class _ContentPreview extends StatelessWidget {
  final SecretContent content;

  const _ContentPreview({required this.content});

  @override
  Widget build(BuildContext context) {
    switch (content.type) {
      case ContentType.text:
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            content.textContent ?? '',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        );
      case ContentType.image:
        return CachedNetworkImage(
          imageUrl: content.storagePath!,
          fit: BoxFit.cover,
          placeholder: (context, url) => const AspectRatio(
            aspectRatio: 1,
            child: Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        );
      case ContentType.video:
        return AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: content.thumbnailPath ?? '',
                fit: BoxFit.cover,
              ),
              const Center(child: Icon(Icons.play_circle_filled, size: 48)),
            ],
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class _TierLockOverlay extends StatelessWidget {
  final SecretContent content;

  const _TierLockOverlay({required this.content});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black54, Colors.transparent],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock, size: 40, color: Colors.white),
              const SizedBox(height: 8),
              Text(
                'Unlock with ${content.minRequiredTier.name} Tier',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.upgrade),
                label: const Text('Upgrade Now'),
                onPressed: () => _showUpgradeDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUpgradeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => UpgradePromptDialog(content: content),
    );
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent();

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        childCount: 5,
      ),
    );
  }
}

class UpgradePromptDialog extends StatelessWidget {
  final SecretContent content;

  const UpgradePromptDialog({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Upgrade Required'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('This content requires ${content.minRequiredTier.name} tier.'),
          const SizedBox(height: 16),
          const Text('Benefits include:'),
          ...content.tierAccess.entries
              .where((e) => e.value)
              .map((e) => ListTile(
                    leading: const Icon(Icons.check_circle),
                    title: Text(e.key.name),
                  )),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Later'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SubscriptionScreen()),
            );
          },
          child: const Text('Upgrade Now'),
        ),
      ],
    );
  }
}
