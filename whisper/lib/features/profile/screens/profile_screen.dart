// ignore_for_file: unused_element

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/features/profile/screens/create_post_screen.dart';
import 'package:whisper/widgets/universal_post_card.dart';
import 'package:whisper/features/profile/screens/profile_view.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String? userId;
  const ProfileScreen({super.key, this.userId});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  bool _isEditing = false;
  bool _isLoading = false;
  late TabController _tabController;
  UserModel? _currentUser;

  // Platform-specific image storage
  File? _profileImage;
  File? _coverImage;
  Uint8List? _profileImageWeb;
  Uint8List? _coverImageWeb;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _migrateFollowerCount();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final targetUserId = widget.userId ?? currentUser?.uid;

    if (targetUserId == null) {
      return const Scaffold(
        body: Center(child: Text('Please login to view profile')),
      );
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(targetUserId)
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
        _currentUser = UserModel.fromJson(userData);

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
                            image: _currentUser?.coverImage != null
                                ? DecorationImage(
                                    image:
                                        NetworkImage(_currentUser!.coverImage!),
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
                                backgroundImage: _currentUser?.photoUrl != null
                                    ? NetworkImage(_currentUser!.photoUrl!)
                                    : null,
                                child: _currentUser?.photoUrl == null
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
                                  _currentUser?.displayName ?? 'Add your name',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                if (_currentUser?.bio != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    _currentUser!.bio!,
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
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromARGB(153, 128, 128, 128),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildStatItem(
                                        'Posts', _currentUser?.postsCount ?? 0),
                                    _buildStatItem('Followers',
                                        _currentUser?.followersCount ?? 0),
                                    _buildStatItem('Following',
                                        _currentUser?.followingCount ?? 0),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Tabs
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(153, 128, 128, 128),
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
                              _buildPostsTab(targetUserId),
                              _buildSubscriptionsTab(targetUserId),
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
                                onPressed: () => _saveProfile(_currentUser),
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
                                        _currentUser?.displayName ?? '';
                                    _bioController.text =
                                        _currentUser?.bio ?? '';
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
          .where('isDeleted', isEqualTo: false)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final posts = snapshot.data?.docs ?? [];

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
                      horizontal: 24,
                      vertical: 12,
                    ),
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

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final postData = posts[index].data() as Map<String, dynamic>;
            return UniversalPostCard(postData: postData);
          },
        );
      },
    );
  }

  Widget _buildSubscriptionsTab(String userId) {
    final scrollController = ScrollController();
    const pageSize = 10;
    final followsRef = FirebaseFirestore.instance
        .collection('follows')
        .where('followerId', isEqualTo: userId)
        .limit(pageSize);

    return StreamBuilder<QuerySnapshot>(
      stream: followsRef.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final follows = snapshot.data?.docs ?? [];

        // Sort in memory instead of using orderBy
        follows.sort((a, b) {
          final aData = a.data() as Map<String, dynamic>;
          final bData = b.data() as Map<String, dynamic>;
          final aTime =
              (aData['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
          final bTime =
              (bData['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
          return bTime.compareTo(aTime); // Descending order
        });

        if (follows.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'You are not following anyone yet',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              // Load more data when reaching the bottom
              final lastDoc = follows.last;
              followsRef
                  .startAfterDocument(lastDoc)
                  .get()
                  .then((querySnapshot) {
                if (querySnapshot.docs.isNotEmpty) {
                  setState(() {
                    follows.addAll(querySnapshot.docs);
                    // Sort the new combined list
                    follows.sort((a, b) {
                      final aData = a.data() as Map<String, dynamic>;
                      final bData = b.data() as Map<String, dynamic>;
                      final aTime =
                          (aData['createdAt'] as Timestamp?)?.toDate() ??
                              DateTime.now();
                      final bTime =
                          (bData['createdAt'] as Timestamp?)?.toDate() ??
                              DateTime.now();
                      return bTime.compareTo(aTime);
                    });
                  });
                }
              });
            }
            return true;
          },
          child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: follows.length + 1, // +1 for loading indicator
            itemBuilder: (context, index) {
              if (index == follows.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: follows.length % pageSize == 0
                        ? const CircularProgressIndicator()
                        : const SizedBox(),
                  ),
                );
              }

              final followData = follows[index].data() as Map<String, dynamic>;
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(followData['followingId'])
                    .get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return const Card(
                      margin: EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        title: LinearProgressIndicator(),
                      ),
                    );
                  }

                  final userData =
                      userSnapshot.data!.data() as Map<String, dynamic>;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 3,
                    shadowColor: Colors.black.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white,
                            const Color(0xFF320064).withOpacity(0.05),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Hero(
                              tag: 'profile-${userData['uid']}',
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF320064),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 28,
                                  backgroundColor: Colors.white,
                                  backgroundImage: userData['photoUrl'] != null
                                      ? NetworkImage(userData['photoUrl'])
                                      : null,
                                  child: userData['photoUrl'] == null
                                      ? const Icon(Icons.person,
                                          color: Color(0xFF320064), size: 32)
                                      : null,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userData['displayName'] ?? 'Anonymous',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  if (userData['bio'] != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      userData['bio'],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(Icons.article_outlined,
                                          size: 14, color: Colors.grey[600]),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${userData['postsCount'] ?? 0} posts',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Icon(Icons.people_outline,
                                          size: 14, color: Colors.grey[600]),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${userData['followerCount'] ?? userData['followersCount'] ?? 0} followers',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                _navigateToUserProfile(userData['uid']);
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF320064),
                                backgroundColor:
                                    const Color(0xFF320064).withOpacity(0.1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                              ),
                              child: const Text('View'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, int value) {
    // Use consistent field name for follower count
    final actualValue =
        label == 'Followers' ? (_currentUser?.followersCount ?? value) : value;

    return GestureDetector(
      onTap: () {
        if (label == 'Followers' || label == 'Following') {
          // Show bottom sheet with list of followers/following
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              builder: (context, scrollController) => Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        label,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('follows')
                            .where(
                              label == 'Followers'
                                  ? 'followingId'
                                  : 'followerId',
                              isEqualTo: widget.userId ??
                                  FirebaseAuth.instance.currentUser?.uid,
                            )
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          final users = snapshot.data!.docs;
                          return ListView.builder(
                            controller: scrollController,
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final userData =
                                  users[index].data() as Map<String, dynamic>;
                              final userId = label == 'Followers'
                                  ? userData['followerId']
                                  : userData['followingId'];

                              return FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(userId)
                                    .get(),
                                builder: (context, userSnapshot) {
                                  if (!userSnapshot.hasData) {
                                    return const SizedBox.shrink();
                                  }

                                  final user = userSnapshot.data!.data()
                                      as Map<String, dynamic>;
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: user['photoUrl'] != null
                                          ? NetworkImage(user['photoUrl'])
                                          : null,
                                    ),
                                    title: Text(
                                        user['displayName'] ?? 'Anonymous'),
                                    subtitle: user['bio'] != null
                                        ? Text(
                                            user['bio'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        : null,
                                    onTap: () {
                                      Navigator.pop(context);
                                      _navigateToUserProfile(userId);
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
      child: Column(
        children: [
          Text(
            actualValue.toString(),
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
      ),
    );
  }

  void _navigateToUserProfile(String userId) {
    // Navigate to user profile
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileView(userId: userId),
      ),
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
    await _saveProfile(_currentUser); // Pass current user model if needed
  }

  Future<void> _updateCoverImage() async {
    await _pickImage(ImageSource.gallery, 'cover');
    await _saveProfile(_currentUser); // Pass current user model if needed
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

  Future<void> _migrateFollowerCount() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId ?? FirebaseAuth.instance.currentUser?.uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data()!;
        if (data.containsKey('followerCount') && data['followersCount'] == 0) {
          await userDoc.reference.update({
            'followersCount': data['followerCount'],
            'followerCount': FieldValue.delete(),
          });
        }
      }
    } catch (e) {
      debugPrint('Error migrating follower count: $e');
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
