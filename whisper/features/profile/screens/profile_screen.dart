import 'package:flutter/material.dart';
// ...existing imports...

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Remove explicit background color to use theme defaults
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Profile'),
        // ...existing code...
      ),
      body: Container(
        // Remove explicit container color
        // color: Theme.of(context).scaffoldBackgroundColor,
        child: Center(
            child: Text('Profile content here',
                style: Theme.of(context).textTheme.bodyLarge)),
      ),
    );
  }
}
