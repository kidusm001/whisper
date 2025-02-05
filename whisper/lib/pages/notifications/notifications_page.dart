import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Implement real notifications
    final notifications = [
      _NotificationItem(
        icon: Icons.favorite,
        color: Colors.red,
        title: 'New Like',
        message: 'John Doe liked your post',
        time: '2 hours ago',
        onTap: () {},
      ),
      _NotificationItem(
        icon: Icons.comment,
        color: Colors.blue,
        title: 'New Comment',
        message: 'Jane Smith commented on your post',
        time: '3 hours ago',
        onTap: () {},
      ),
      _NotificationItem(
        icon: Icons.person_add,
        color: AppTheme.primaryColor,
        title: 'New Follower',
        message: 'Mike Johnson started following you',
        time: '5 hours ago',
        onTap: () {},
      ),
      _NotificationItem(
        icon: Icons.star,
        color: Colors.amber,
        title: 'Subscription Update',
        message: 'Your subscription will renew in 3 days',
        time: '1 day ago',
        onTap: () {},
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Marked all as read')),
              );
            },
          ),
        ],
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notifications yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) => notifications[index],
            ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String message;
  final String time;
  final VoidCallback onTap;

  const _NotificationItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.message,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message),
          const SizedBox(height: 4),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
