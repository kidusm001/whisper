// lib/features/profile/screens/create_post_screen.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';

export 'create_post_screen.dart' show CreatePostScreen;

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  File? _image;
  Uint8List? _imageWeb;
  bool _isPublished = true;
  String? _selectedTier;
  final List<String> _availableTiers = ['Free', 'Premium'];

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageWeb = bytes;
          _image = null;
        });
      } else {
        setState(() {
          _image = File(pickedFile.path);
          _imageWeb = null;
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _createPost() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('You must be logged in to create a post.')),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        actions: [
          TextButton(
            onPressed: _createPost,
            child: Text(
              'Post',
              style:
                  TextStyle(color: theme.colorScheme.onPrimary, fontSize: 16),
            ),
          ),
        ],
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: theme.colorScheme.surface,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _titleController,
                      style: theme.textTheme.bodyLarge,
                      decoration: InputDecoration(
                        hintText: 'Title',
                        hintStyle: TextStyle(color: theme.hintColor),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _contentController,
                style: theme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'Write a caption...',
                  hintStyle: TextStyle(color: theme.hintColor),
                  border: InputBorder.none,
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _pickImage(ImageSource.gallery),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    image: (_image != null || _imageWeb != null)
                        ? DecorationImage(
                            image: kIsWeb
                                ? MemoryImage(_imageWeb!)
                                    as ImageProvider<Object>
                                : FileImage(_image!) as ImageProvider<Object>,
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: (_image == null && _imageWeb == null)
                      ? Icon(Icons.add_a_photo,
                          size: 50, color: theme.hintColor)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedTier,
                style: theme.textTheme.bodyLarge,
                dropdownColor: theme.cardColor,
                decoration: InputDecoration(
                  labelText: 'Select Tier (Optional)',
                  labelStyle: TextStyle(color: theme.hintColor),
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.primary),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.dividerColor),
                  ),
                ),
                items: _availableTiers.map((String tier) {
                  return DropdownMenuItem<String>(
                    value: tier,
                    child: Text(tier),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTier = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Publish Post',
                    style: theme.textTheme.bodyLarge,
                  ),
                  Switch(
                    value: _isPublished,
                    activeColor: theme.colorScheme.primary,
                    onChanged: (value) {
                      setState(() {
                        _isPublished = value;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
