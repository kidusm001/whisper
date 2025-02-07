import 'package:flutter/material.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  bool _isLoading = false;

  // Add mounted checks for async operations
  Future<void> _handleAsyncOperation() async {
    setState(() => _isLoading = true);

    try {
      // Your async operation here
      await Future.delayed(const Duration(seconds: 2)); // Example delay

      if (!mounted) return;

      // Now it's safe to use context
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Operation completed')),
      );

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Post')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : const Center(child: Text('Create Post Screen Content')),
    );
  }
}
