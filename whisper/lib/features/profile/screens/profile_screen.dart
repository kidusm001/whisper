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
import 'package:whisper/features/widgets/post_card.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
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
          backgroundColor: Colors.grey[50],
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
                            color: Colors.grey[200],
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
                                            Colors.black.withOpacity(0.7),
                                      ),
                                      child: const Text('Change Cover'),
                                    ),
                                  ),
                                )
                              : null,
                        ),

                        // Profile Avatar (inside Column, so it scrolls)
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey[200],
                                backgroundImage: user.photoUrl != null
                                    ? NetworkImage(user.photoUrl!)
                                    : null,
                                child: user.photoUrl == null
                                    ? const Icon(Icons.person,
                                        size: 50, color: Colors.grey)
                                    : null,
                              ),
                            ),
                            if (_isEditing)
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: const Color(0xFF320064),
                                  child: IconButton(
                                    icon:
                                        const Icon(Icons.camera_alt, size: 18),
                                    color: Colors.white,
                                    onPressed: _updateProfileImage,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Profile Info (Name and Bio)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              if (_isEditing) ...[
                                TextField(
                                  controller: _nameController,
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                    labelText: 'Name',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _bioController,
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  decoration: const InputDecoration(
                                    labelText: 'Bio',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ] else ...[
                                Text(
                                  user.displayName ?? 'Add your name',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                if (user.bio != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    user.bio!,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16,
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
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
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
                          icon: const Icon(Icons.arrow_back,
                              color: Colors
                                  .white), // Keep white for visibility on cover
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
                                icon: const Icon(Icons.edit,
                                    color: Colors
                                        .white), // Keep white for visibility
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
          debugPrint('Posts stream error: ${snapshot.error}');
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

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
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
                  child: const Text('Create Post',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        }

        final posts = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          // Convert Timestamp to DateTime if needed
          if (data['createdAt'] is Timestamp) {
            data['createdAt'] = (data['createdAt'] as Timestamp).toDate();
          }
          return PostModel.fromJson(data);
        }).toList();

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: posts.length,
          itemBuilder: (context, index) => PostCard(post: posts[index]),
        );
      },
    );
  }

  Widget _buildPostCard(PostModel post) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (post.mediaUrls.isNotEmpty)
            Container(
              height: 200,
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
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(post.content),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('${post.likesCount} likes'),
                    const SizedBox(width: 16),
                    Text('${post.commentsCount} comments'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
