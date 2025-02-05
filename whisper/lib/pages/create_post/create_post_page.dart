import 'package:flutter/material.dart';
import '../../models/post_model.dart';
import '../../theme/app_theme.dart';
import '../../services/firestore_service.dart';
import '../../services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _selectedTier = 'general';
  bool _isLoading = false;
  final _firestoreService = FirestoreService();
  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    _initializeAuthService();
  }

  Future<void> _initializeAuthService() async {
    _authService = AuthService(await SharedPreferences.getInstance());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _createPost() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _authService.getCurrentUser();
      if (user == null) {
        throw Exception('User not logged in');
      }

      final post = PostModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        creatorId: user.uid,
        creatorName: user.displayName ?? 'Anonymous',
        creatorPhotoUrl: user.photoUrl,
        title: _titleController.text,
        content: _contentController.text,
        accessTier: _selectedTier,
        createdAt: DateTime.now(),
      );

      await _firestoreService.createPost(post);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post created successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error creating post'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          TextButton.icon(
            onPressed: _isLoading ? null : _createPost,
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.send, color: Colors.white),
            label: const Text(
              'Post',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<String>(
              value: _selectedTier,
              decoration: const InputDecoration(
                labelText: 'Access Tier',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'general',
                  child: Text('General Access'),
                ),
                DropdownMenuItem(
                  value: 'backstage',
                  child: Text('Backstage Access'),
                ),
                DropdownMenuItem(
                  value: 'inner',
                  child: Text('Inner Circle'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedTier = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 10,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some content';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                // TODO: Implement image upload
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Image upload coming soon!')),
                );
              },
              icon: const Icon(Icons.image),
              label: const Text('Add Image'),
            ),
          ],
        ),
      ),
    );
  }
}
