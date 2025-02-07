import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/follows_provider.dart';

class MembershipScreen extends ConsumerWidget {
  const MembershipScreen({Key? key}) : super(key: key);

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
              child: Text('You haven\'t followed any creators yet.'),
            )
          : ListView.builder(
              itemCount: following.length,
              itemBuilder: (context, index) {
                final creatorId = following[index].key;
                final tier =
                    followState.subscriptionTiers[creatorId] ?? 'basic';

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
                    subtitle: Text(
                        'Following since ${DateTime.now().toString().split(' ')[0]}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.person_remove),
                      color: Colors.red,
                      onPressed: () {
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
                    onTap: () {
                      // Navigate to creator's profile
                      // TODO: Implement navigation to creator profile
                    },
                  ),
                );
              },
            ),
    );
  }
}
