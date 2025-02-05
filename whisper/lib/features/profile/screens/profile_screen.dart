import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/user_model.dart';
import '../../models/post_model.dart';
import '../../models/subscription_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  bool _isEditing = false;
  bool _isLoading = false;
  late TabController _tabController;
  final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('Please login to view profile')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                // Create a new user document if it doesn't exist
                _createUserDocument(currentUser);
                return const Center(child: CircularProgressIndicator());
              }

              final userData = snapshot.data!.data() as Map<String, dynamic>;
              userData['uid'] = currentUser.uid; // Add uid to the data
              
              final user = UserModel.fromJson(userData);

              return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    expandedHeight: 200,
                    floating: false,
                    pinned: true,
                    backgroundColor: Colors.white,
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              image: user.coverImage != null
                                  ? DecorationImage(
                                      image: NetworkImage(user.coverImage!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                          ),
                          if (_isEditing)
                            Positioned(
                              right: 16,
                              bottom: 16,
                              child: ElevatedButton(
                                onPressed: _updateCoverImage,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black.withOpacity(0.7),
                                ),
                                child: const Text('Change Cover'),
                              ),
                            ),
                        ],
                      ),
                    ),
                    actions: [
                      if (!_isEditing)
                        TextButton(
                          onPressed: () => setState(() => _isEditing = true),
                          child: const Text(
                            'Edit Profile',
                            style: TextStyle(color: Color(0xFF320064)),
                          ),
                        )
                      else
                        TextButton(
                          onPressed: () => _saveProfile(user),
                          child: const Text(
                            'Save',
                            style: TextStyle(color: Color(0xFF320064)),
                          ),
                        ),
                    ],
                  ),
                ],
                body: Column(
                  children: [
                    Transform.translate(
                      offset: const Offset(0, -40),
                      child: _buildProfileHeader(user),
                    ),
                    TabBar(
                      controller: _tabController,
                      labelColor: Colors.black,
                      tabs: const [
                        Tab(text: 'Posts'),
                        Tab(text: 'About'),
                        Tab(text: 'Subscriptions'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildPostsTab(user.uid),
                          _buildAboutTab(user),
                          _buildSubscriptionsTab(user.uid),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(UserModel user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[200],
                backgroundImage: user.photoUrl != null
                    ? NetworkImage(user.photoUrl!)
                    : null,
                child: user.photoUrl == null
                    ? const Icon(Icons.person, size: 50, color: Colors.grey)
                    : null,
              ),
              if (_isEditing)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFF320064),
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, size: 18),
                      color: Colors.white,
                      onPressed: _updateProfileImage,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isEditing) ...[
            TextField(
              controller: _nameController..text = user.displayName ?? '',
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _bioController..text = user.bio ?? '',
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
            ),
            if (user.bio != null)
              Text(
                user.bio!,
                style: TextStyle(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
          ],
        ],
      ),
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
          return const Center(child: Text('Error loading posts'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final posts = snapshot.data?.docs
            .map((doc) => PostModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList() ?? [];

        if (posts.isEmpty) {
          return const Center(child: Text('No posts yet'));
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

  Widget _buildAboutTab(UserModel user) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Stats',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Posts', user.postsCount),
              _buildStatItem('Followers', user.followersCount),
              _buildStatItem('Following', user.followingCount),
            ],
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
            .map((doc) => SubscriptionModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList() ?? [];

        if (subscriptions.isEmpty) {
          return const Center(child: Text('No active subscriptions'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: subscriptions.length,
          itemBuilder: (context, index) => _buildSubscriptionCard(subscriptions[index]),
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
            subtitle: Text('Subscribed since: ${_formatDate(subscription.startDate)}'),
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

  Future<void> _updateProfileImage() async {
    setState(() => _isLoading = true);
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${FirebaseAuth.instance.currentUser!.uid}_profile.jpg');

        final uploadTask = await storageRef.putFile(File(image.path));
        final downloadUrl = await uploadTask.ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'photoUrl': downloadUrl,
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile image')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateCoverImage() async {
    setState(() => _isLoading = true);
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${FirebaseAuth.instance.currentUser!.uid}_cover.jpg');

        final uploadTask = await storageRef.putFile(File(image.path));
        final downloadUrl = await uploadTask.ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'coverImage': downloadUrl,
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update cover image')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile(UserModel currentUser) async {
    setState(() => _isLoading = true);

    try {
      final updatedUser = currentUser.copyWith(
        displayName: _nameController.text,
        bio: _bioController.text,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update(updatedUser.toJson());

      setState(() => _isEditing = false);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile')),
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