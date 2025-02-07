import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explore Creators')),
      body: const Center(
        child: Text('Explore Screen Content'),
      ),
    );
  }
}
