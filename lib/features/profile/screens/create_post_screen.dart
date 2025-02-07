// lib/features/profile/screens/create_post_screen.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../../features/models/post_model.dart';
import '../../../providers/posts_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

export 'create_post_screen.dart' show CreatePostScreen;

class CreatePostScreen extends ConsumerStatefulWidget {
  final PostModel? post;

  const CreatePostScreen({super.key, this.post});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  File? _image;
  Uint8List? _imageWeb;
  bool _isPublished = true;
  String? _selectedTier;
  bool _isLoading = false;
  final List<String> _availableTiers = ['basic', 'premium', 'vip'];

  @override
  void initState() {
    super.initState();
    if (widget.post != null) {
      _titleController.text = widget.post!.title;
      _contentController.text = widget.post!.content;
      _selectedTier = widget.post!.tier;
      _isPublished = widget.post!.isPublished;
    }
  }

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

  Future<String?> _uploadImageToSupabase(
      dynamic imageFile, String userId) async {
    if (imageFile == null) return null;

    final supabaseClient = supabase.Supabase.instance.client;
    final fileName =
        '${userId}_post_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final imagePath = '$userId/posts/$fileName';

    try {
      if (imageFile is Uint8List) {
        await supabaseClient.storage.from('images').uploadBinary(
              imagePath,
              imageFile,
              fileOptions: const supabase.FileOptions(
                  cacheControl: '3600', upsert: false),
            );
      } else if (imageFile is File) {
        await supabaseClient.storage.from('images').upload(
              imagePath,
              imageFile,
              fileOptions: const supabase.FileOptions(
                  cacheControl: '3600', upsert: false),
            );
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
    if (_titleController.text.trim().isEmpty ||
        _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('You must be logged in to create a post.')),
        );
        return;
      }

      // Get user data from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception('User data not found');
      }

      final userData = userDoc.data()!;
      final userName = userData['displayName'] ?? 'Anonymous';

      // Upload image if selected
      String? imageUrl;
      if (_image != null || _imageWeb != null) {
        imageUrl = await _uploadImageToSupabase(
          kIsWeb ? _imageWeb : _image,
          currentUser.uid,
        );
      }

      final postId = widget.post?.id ?? const Uuid().v4();
      final newPost = PostModel(
        id: postId,
        authorId: currentUser.uid,
        authorName: userName,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        mediaUrls: imageUrl != null ? [imageUrl] : widget.post?.mediaUrls ?? [],
        mediaType: imageUrl != null ? 'image' : 'text',
        likesCount: widget.post?.likesCount ?? 0,
        commentsCount: widget.post?.commentsCount ?? 0,
        tier: _selectedTier,
        isPublished: _isPublished,
        createdAt: widget.post?.createdAt ?? DateTime.now(),
      );

      if (widget.post != null) {
        await _updatePost(newPost);
      } else {
        await _createNewPost(newPost);
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating post: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updatePost(PostModel post) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(post.id)
        .update(post.toJson());
  }

  Future<void> _createNewPost(PostModel post) async {
    final batch = FirebaseFirestore.instance.batch();

    final postRef = FirebaseFirestore.instance.collection('posts').doc(post.id);
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(post.authorId);

    batch.set(postRef, post.toJson());
    batch.update(userRef, {'postsCount': FieldValue.increment(1)});

    await batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post != null ? 'Edit Post' : 'Create Post'),
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: CircularProgressIndicator(),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextButton(
                onPressed: _createPost,
                child: Text(
                  widget.post != null ? 'Save' : 'Post',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
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
              TextField(
                controller: _titleController,
                style: theme.textTheme.titleLarge,
                decoration: InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(color: theme.hintColor),
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _contentController,
                style: theme.textTheme.bodyLarge,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Write your post...',
                  hintStyle: TextStyle(color: theme.hintColor),
                  border: InputBorder.none,
                ),
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
                                ? MemoryImage(_imageWeb!) as ImageProvider
                                : FileImage(_image!) as ImageProvider,
                            fit: BoxFit.cover,
                          )
                        : widget.post?.mediaUrls.isNotEmpty == true
                            ? DecorationImage(
                                image:
                                    NetworkImage(widget.post!.mediaUrls.first),
                                fit: BoxFit.cover,
                              )
                            : null,
                  ),
                  child: (_image == null &&
                          _imageWeb == null &&
                          widget.post?.mediaUrls.isEmpty != false)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo,
                                size: 50, color: theme.hintColor),
                            const SizedBox(height: 8),
                            Text(
                              'Add Image',
                              style: TextStyle(color: theme.hintColor),
                            ),
                          ],
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedTier,
                decoration: InputDecoration(
                  labelText: 'Select Tier',
                  border: const OutlineInputBorder(),
                ),
                items: _availableTiers.map((String tier) {
                  return DropdownMenuItem<String>(
                    value: tier,
                    child: Text(tier.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTier = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text('Publish Post', style: theme.textTheme.titleMedium),
                  const Spacer(),
                  Switch(
                    value: _isPublished,
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

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
