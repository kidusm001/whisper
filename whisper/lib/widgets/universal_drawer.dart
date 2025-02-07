import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whisper/features/profile/screens/profile_screen.dart';
import 'package:provider/provider.dart'; // <-- Added import
import 'package:whisper/theme/theme_service.dart'; // <-- Added import for ThemeService

class UniversalDrawer extends StatelessWidget {
  const UniversalDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser?.uid)
            .get(),
        builder: (context, snapshot) {
          final userData = snapshot.data?.data() as Map<String, dynamic>? ?? {};
          final String profileImage = [
            if (userData['photoUrl'] != null) userData['photoUrl'] as String,
            if (userData['photoURL'] != null) userData['photoURL'] as String,
            if (userData['profileImage'] != null)
              userData['profileImage'] as String,
            if (userData['avatar'] != null) userData['avatar'] as String,
          ].firstWhere((image) => image.trim().isNotEmpty,
              orElse: () =>
                  'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y');

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(profileImage),
                ),
                accountName: Text(
                  userData['displayName'] ?? 'User',
                  style: const TextStyle(fontSize: 18),
                ),
                accountEmail: Text(userData['email'] ?? ''),
              ),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.bookmark_outline),
                title: const Text('Saved Posts'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              // Add theme toggle switch
              Consumer<ThemeService>(
                builder: (context, themeService, _) {
                  return SwitchListTile(
                    secondary: const Icon(Icons.brightness_6),
                    title: const Text('Dark Mode'),
                    value: themeService.isDarkMode,
                    onChanged: (value) {
                      themeService.setThemeMode(
                          value ? ThemeMode.dark : ThemeMode.light);
                    },
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.pop(context); // Close the drawer
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
