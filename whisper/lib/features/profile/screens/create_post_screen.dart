// lib/features/profile/screens/create_post_screen.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:whisper/features/models/post_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // <-- NEW import

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
  bool _mounted = true;

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
    _mounted = false;
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<String?> _uploadImageToSupabase(
      dynamic imageFile, String imageType, String userId) async {
    if (imageFile == null) return null;

    final supabaseClient = Supabase.instance.client;
    final fileName =
        '${userId}_${imageType}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final imagePath = '$userId/$imageType/$fileName';

    debugPrint("Uploading to path: $imagePath");
    debugPrint(
        "Current User UID (from FirebaseAuth): ${FirebaseAuth.instance.currentUser?.uid}");

    try {
      if (imageFile is Uint8List) {
        await supabaseClient.storage.from('images').uploadBinary(
              imagePath,
              imageFile,
              fileOptions:
                  const FileOptions(cacheControl: '3600', upsert: false),
            );
      } else if (imageFile is File) {
        await supabaseClient.storage.from('images').upload(
              imagePath,
              imageFile,
              fileOptions:
                  const FileOptions(cacheControl: '3600', upsert: false),
            );
      } else {
        throw Exception('Unsupported image file type');
      }

      final publicUrl =
          supabaseClient.storage.from('images').getPublicUrl(imagePath);
      return publicUrl;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: $e')),
        );
      }
      return null;
    }
  }

  Future<void> _createPost() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      if (_mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('You must be logged in to create a post.')),
        );
      }
      return;
    }

    // Store context in local variable
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    // Show loading indicator
    if (_mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
    }

    try {
      var uuid = const Uuid();
      final newPostId = uuid.v4();
      String? imageUrl;

      // Image Upload Section
      if (_image != null || _imageWeb != null) {
        imageUrl = await _uploadImageToSupabase(
          kIsWeb ? _imageWeb : _image,
          'post',
          currentUser.uid,
        );

        if (imageUrl == null) {
          if (_mounted) {
            scaffoldMessenger.showSnackBar(
              const SnackBar(content: Text('Failed to upload image.')),
            );
            navigator.pop(); // Dismiss loading indicator
          }
          return;
        }
      }

      final newPost = PostModel(
        id: newPostId,
        authorId: currentUser.uid,
        title: _titleController.text,
        content: _contentController.text,
        mediaUrls: imageUrl != null ? [imageUrl] : [],
        mediaType: _image != null || _imageWeb != null ? 'image' : 'text',
        likesCount: 0,
        commentsCount: 0,
        tier: _selectedTier,
        isPublished: _isPublished,
        createdAt: DateTime.now(),
      );

      await addPostToFirestore(newPost);

      if (_mounted) {
        navigator.pop(); // Dismiss loading indicator
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Post created successfully!')),
        );
        navigator.pop(); // Go back to the previous screen
      }
    } catch (e) {
      if (_mounted) {
        navigator.pop(); // Dismiss loading indicator
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Failed to create post: $e')),
        );
      }
    }
  }

  Future<void> addPostToFirestore(PostModel post) async {
    final firestore = FirebaseFirestore.instance;

    try {
      // First, get the actual post count by querying posts collection
      final postsCount = await firestore
          .collection('posts')
          .where('authorId', isEqualTo: post.authorId)
          .count()
          .get();

      final actualCount = postsCount.count ?? 0; // Handle null case

      // Use a batch write to ensure atomicity
      final batch = firestore.batch();

      // Add the post document
      final postRef = firestore.collection('posts').doc(post.id);
      batch.set(postRef, post.toJson());

      // Update user document with accurate post count
      final userRef = firestore.collection('users').doc(post.authorId);
      batch.update(userRef, {'postsCount': actualCount + 1});

      await batch.commit();

      debugPrint('Updated post count to: ${actualCount + 1}');
    } catch (e) {
      debugPrint('Error creating post: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        backgroundColor: const Color(0xFF320064),
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _createPost,
            child: const Text(
              'Post',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
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
                    backgroundColor: Colors.grey[300],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        hintText: 'Title',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: 'Write a caption...',
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
                    color: Colors.grey[200],
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
                      ? const Icon(Icons.add_a_photo,
                          size: 50, color: Colors.grey)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedTier,
                decoration: InputDecoration(
                  labelText: 'Select Tier (Optional)',
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[600]!),
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
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  Switch(
                    value: _isPublished,
                    activeColor: const Color(0xFF320064),
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
