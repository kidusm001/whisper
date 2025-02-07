// ignore_for_file: unused_element

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../models/user_model.dart';
import '../../models/post_model.dart';
import '../../models/subscription_model.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:whisper/features/profile/screens/create_post_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  bool _isEditing = false;
  bool _isLoading = false;
  late TabController _tabController;

  // Platform-specific image storage
  File? _profileImage;
  File? _coverImage;
  Uint8List? _profileImageWeb;
  Uint8List? _coverImageWeb;

  UserModel? user;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      if (doc.exists) {
        setState(() {
          user = UserModel.fromJson(doc.data()!);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('Please login to view profile')),
      );
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final user = UserModel.fromJson(userData);

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xFF320064),
            foregroundColor: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CreatePostScreen()),
              );
            },
            child: const Icon(Icons.add),
          ),
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              // Main Scrollable Content
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        // Cover Image
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            image: user.coverImage != null
                                ? DecorationImage(
                                    image: NetworkImage(user.coverImage!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: _isEditing
                              ? Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: ElevatedButton(
                                      onPressed: _updateCoverImage,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            theme.colorScheme.primary,
                                        foregroundColor:
                                            theme.colorScheme.onPrimary,
                                      ),
                                      child: const Text('Change Cover'),
                                    ),
                                  ),
                                )
                              : null,
                        ),

                        // Profile Avatar
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: theme.colorScheme.surface,
                                backgroundImage: user.photoUrl != null
                                    ? NetworkImage(user.photoUrl!)
                                    : null,
                                child: user.photoUrl == null
                                    ? Icon(Icons.person,
                                        size: 50, color: theme.hintColor)
                                    : null,
                              ),
                            ),
                            if (_isEditing)
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: theme.colorScheme.primary,
                                  child: IconButton(
                                    icon:
                                        const Icon(Icons.camera_alt, size: 18),
                                    color: theme.colorScheme.onPrimary,
                                    onPressed: _updateProfileImage,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Profile Info
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              if (_isEditing) ...[
                                TextField(
                                  controller: _nameController,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyLarge,
                                  decoration: InputDecoration(
                                    labelText: 'Name',
                                    border: const OutlineInputBorder(),
                                    labelStyle:
                                        TextStyle(color: theme.hintColor),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _bioController,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyLarge,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    labelText: 'Bio',
                                    border: const OutlineInputBorder(),
                                    labelStyle:
                                        TextStyle(color: theme.hintColor),
                                  ),
                                ),
                              ] else ...[
                                Text(
                                  user.displayName ?? 'Add your name',
                                  style:
                                      theme.textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                if (user.bio != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    user.bio!,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: theme.hintColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ],
                              const SizedBox(height: 24),
                              // Stats Row
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: theme.cardColor,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.shadowColor.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildStatItem('Posts', user.postsCount),
                                    _buildStatItem(
                                        'Followers', user.followersCount),
                                    _buildStatItem(
                                        'Following', user.followingCount),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Tabs
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: TabBar(
                            controller: _tabController,
                            labelColor: const Color(0xFF320064),
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: const Color(0xFF320064),
                            tabs: const [
                              Tab(text: 'Posts'),
                              Tab(text: 'Subscriptions'),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height - 450,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              _buildPostsTab(user.uid),
                              _buildSubscriptionsTab(user.uid),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Navigation Buttons (top layer)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.transparent, // Make it transparent
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 10,
                    left: 10,
                    right: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: _isEditing
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.black.withOpacity(0.7),
                                ),
                                onPressed: () => _saveProfile(user),
                                child: const Text('Save',
                                    style: TextStyle(color: Colors.white)),
                              )
                            : IconButton(
                                icon: Icon(Icons.edit,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black
                                        : Colors.white),
                                onPressed: () {
                                  setState(() {
                                    _isEditing = true;
                                    _nameController.text =
                                        user.displayName ?? '';
                                    _bioController.text = user.bio ?? '';
                                  });
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              // Loading Overlay
              if (_isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black26,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPostsTab(String userId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .where('authorId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Error loading posts'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() {}),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final posts = snapshot.data!.docs
            .map(
                (doc) => PostModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList();

        if (posts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Share your first post with your followers!'),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF320064),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreatePostScreen()),
                    );
                  },
                  child: const Text(
                    'Create Post',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: posts.length,
          itemBuilder: (context, index) => _buildPostCard(posts[index]),
        );
      },
    );
  }

  Widget _buildPostCard(PostModel post) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  post.authorId == FirebaseAuth.instance.currentUser?.uid
                      ? user?.photoUrl ?? 'https://placeholder.com/50x50'
                      : 'https://placeholder.com/50x50'),
            ),
            title: Text(
              post.authorName ?? 'Anonymous',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: post.tier != null
                ? Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getTierColor(post.tier!).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _getTierColor(post.tier!)),
                    ),
                    child: Text(
                      post.tier!.toUpperCase(),
                      style: TextStyle(
                        color: _getTierColor(post.tier!),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : null,
            trailing: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: theme.hintColor),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: theme.iconTheme.color),
                      const SizedBox(width: 8),
                      const Text('Edit'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      const Icon(Icons.delete, color: Colors.red),
                      const SizedBox(width: 8),
                      const Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'edit') {
                  _editPost(post);
                } else if (value == 'delete') {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Post'),
                      content: const Text(
                          'Are you sure you want to delete this post?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            _deletePost(post.id);
                            Navigator.pop(context);
                          },
                          child: const Text('Delete',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
          if (post.mediaUrls.isNotEmpty)
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(post.mediaUrls.first),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  post.content,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.favorite_border,
                        size: 16, color: theme.hintColor),
                    const SizedBox(width: 4),
                    Text(
                      '${post.likesCount} likes',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.comment_outlined,
                        size: 16, color: theme.hintColor),
                    const SizedBox(width: 4),
                    Text(
                      '${post.commentsCount} comments',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _formatDate(post.createdAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getTierColor(String tier) {
    switch (tier.toLowerCase()) {
      case 'basic':
        return Colors.blue;
      case 'premium':
        return Colors.purple;
      case 'vip':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget _buildSubscriptionsTab(String userId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('subscriptions')
          .where('subscriberId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading subscriptions'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final subscriptions = snapshot.data?.docs
                .map((doc) => SubscriptionModel.fromJson(
                    doc.data() as Map<String, dynamic>))
                .toList() ??
            [];

        if (subscriptions.isEmpty) {
          return const Center(child: Text('No active subscriptions'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: subscriptions.length,
          itemBuilder: (context, index) =>
              _buildSubscriptionCard(subscriptions[index]),
        );
      },
    );
  }

  Widget _buildSubscriptionCard(SubscriptionModel subscription) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(subscription.creatorId)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }

        final creator = UserModel.fromJson(
          snapshot.data?.data() as Map<String, dynamic>? ?? {},
        );

        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: creator.photoUrl != null
                  ? NetworkImage(creator.photoUrl!)
                  : null,
            ),
            title: Text(creator.displayName ?? 'Unknown Creator'),
            subtitle: Text(
                'Subscribed since: ${_formatDate(subscription.startDate)}'),
            trailing: Text('\$${subscription.amount}/month'),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _pickImage(ImageSource source, String type) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          if (type == 'profile') {
            _profileImageWeb = bytes;
            _profileImage = null; // Clear other format
          } else {
            _coverImageWeb = bytes;
            _coverImage = null; // Clear other format
          }
        });
      } else {
        setState(() {
          if (type == 'profile') {
            _profileImage = File(pickedFile.path);
            _profileImageWeb = null; // Clear other format
          } else {
            _coverImage = File(pickedFile.path);
            _coverImageWeb = null; // Clear other format
          }
        });
      }
    }
  }

  Future<String?> _uploadImageToSupabase(
      dynamic imageFile, String imageType, String userId) async {
    if (imageFile == null) return null;

    final supabaseClient = supabase.Supabase.instance.client;
    final fileName =
        '${userId}_${imageType}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final imagePath = '$userId/$imageType/$fileName';

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

  Future<void> _updateProfileImage() async {
    await _pickImage(ImageSource.gallery, 'profile');
    await _saveProfile(null); // Pass current user model if needed
  }

  Future<void> _updateCoverImage() async {
    await _pickImage(ImageSource.gallery, 'cover');
    await _saveProfile(null); // Pass current user model if needed
  }

  Future<void> _saveProfile(UserModel? currentUser) async {
    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser!;
      Map<String, dynamic> updates = {};

      // Handle profile image upload
      if (kIsWeb && _profileImageWeb != null) {
        final profileUrl =
            await _uploadImageToSupabase(_profileImageWeb, 'profile', user.uid);
        if (profileUrl != null) updates['photoUrl'] = profileUrl;
      } else if (!kIsWeb && _profileImage != null) {
        final profileUrl =
            await _uploadImageToSupabase(_profileImage, 'profile', user.uid);
        if (profileUrl != null) updates['photoUrl'] = profileUrl;
      }

      // Handle cover image upload
      if (kIsWeb && _coverImageWeb != null) {
        final coverUrl =
            await _uploadImageToSupabase(_coverImageWeb, 'cover', user.uid);
        if (coverUrl != null) updates['coverImage'] = coverUrl;
      } else if (!kIsWeb && _coverImage != null) {
        final coverUrl =
            await _uploadImageToSupabase(_coverImage, 'cover', user.uid);
        if (coverUrl != null) updates['coverImage'] = coverUrl;
      }

      // Add other profile updates if in editing mode
      if (_isEditing) {
        updates['displayName'] = _nameController.text.trim();
        updates['bio'] = _bioController.text.trim();
      }

      if (updates.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update(updates);
      }

      setState(() {
        _isEditing = false;
        // Clear image buffers after successful upload
        _profileImage = null;
        _coverImage = null;
        _profileImageWeb = null;
        _coverImageWeb = null;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _createUserDocument(User user) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'email': user.email,
        'displayName': user.displayName,
        'photoUrl': user.photoURL,
        'createdAt': FieldValue.serverTimestamp(),
        'postsCount': 0,
        'followersCount': 0,
        'followingCount': 0,
      });

      // If the user has a photoURL (e.g., from Google Sign-In), upload it to Supabase
      if (user.photoURL != null && user.photoURL!.isNotEmpty) {
        // Download the image from the URL
        final response = await http.get(Uri.parse(user.photoURL!));
        if (response.statusCode == 200) {
          // Create a temporary file
          final tempDir = await getTemporaryDirectory();
          final tempFile = File('${tempDir.path}/temp_profile_image.jpg');
          await tempFile.writeAsBytes(response.bodyBytes);

          // Upload the image to Supabase
          final imageUrl =
              await _uploadImageToSupabase(tempFile, 'profile', user.uid);

          // Update the Firestore document with the Supabase URL
          if (imageUrl != null) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .update({'photoUrl': imageUrl});
          }
          // Delete the temporary file
          await tempFile.delete();
        }
      }
    } catch (e) {
      debugPrint('Error creating user document: $e');
    }
  }

  Future<void> _editPost(PostModel post) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreatePostScreen(post: post),
      ),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post updated successfully')),
      );
    }
  }

  Future<void> _deletePost(String postId) async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      final postRef =
          FirebaseFirestore.instance.collection('posts').doc(postId);
      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid);

      batch.delete(postRef);
      batch.update(userRef, {'postsCount': FieldValue.increment(-1)});

      await batch.commit();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post deleted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting post: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _tabController.dispose();
    super.dispose();
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
