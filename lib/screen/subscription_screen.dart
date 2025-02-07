import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/follows_provider.dart';

class MembershipsScreen extends ConsumerWidget {
  const MembershipsScreen({Key? key}) : super(key: key);

  String _getTierName(String tier) {
    switch (tier) {
      case 'basic':
        return 'Basic';
      case 'premium':
        return 'Premium';
      case 'vip':
        return 'VIP';
      default:
        return 'Unknown';
    }
  }

  Color _getTierColor(BuildContext context, String tier) {
    switch (tier) {
      case 'basic':
        return Colors.blue;
      case 'premium':
        return Colors.purple;
      case 'vip':
        return Colors.orange;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followState = ref.watch(followsProvider);
    final following = followState.following.entries.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Memberships'),
      ),
      body: following.isEmpty
          ? const Center(
              child: Text('You haven\'t subscribed to any creators yet.'),
            )
          : ListView.builder(
              itemCount: following.length,
              itemBuilder: (context, index) {
                final creatorId = following[index].key;
                final tier =
                    followState.subscriptionTiers[creatorId] ?? 'basic';
                final tierName = _getTierName(tier);
                final tierColor = _getTierColor(context, tier);

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundImage:
                          NetworkImage('https://placeholder.com/50x50'),
                    ),
                    title: const Text(
                        'Creator Name'), // This should come from a creators provider
                    subtitle: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: tierColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: tierColor),
                          ),
                          child: Text(
                            tierName,
                            style: TextStyle(
                              color: tierColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Since ${DateTime.now().toString().split(' ')[0]}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.person_remove),
                      color: Colors.red,
                      onPressed: () {
                        // Show confirmation dialog
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Unfollow Creator'),
                            content: const Text(
                                'Are you sure you want to unfollow this creator?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  ref
                                      .read(followsProvider.notifier)
                                      .unfollowCreator(creatorId);
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Unfollow',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
