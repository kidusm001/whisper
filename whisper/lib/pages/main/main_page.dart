import 'package:flutter/material.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  UserModel? _currentUser;
  final _posts = <PostModel>[];
  bool _isLoading = true;
  late final AuthService _authService;
  late final FirestoreService _firestoreService;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    final prefs = await SharedPreferences.getInstance();
    _authService = AuthService(prefs);
    _firestoreService = FirestoreService();
    await _firestoreService.initialize();
    await _loadUserData();
    await _loadPosts();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await _authService.getCurrentUser();
      if (mounted) {
        setState(() {
          _currentUser = user;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error loading user data')),
        );
      }
    }
  }

  Future<void> _loadPosts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final posts = await _firestoreService.getPostsForUser(
        _currentUser?.uid ?? '',
        _currentUser?.subscriptionTier ?? 'none',
      );

      if (mounted) {
        setState(() {
          _posts.clear();
          _posts.addAll(posts);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error loading posts')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _toggleLike(PostModel post) async {
    if (_currentUser == null) return;
    await _firestoreService.toggleLike(post.id, _currentUser!.uid);
    await _loadPosts();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 2) {
      Navigator.pushNamed(context, '/tier_list');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Whisper',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF9146FF),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await _authService.logout();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Home Feed
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _loadPosts,
                  child: _posts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.article_outlined,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No posts available',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: _posts.length,
                          itemBuilder: (context, index) {
                            final post = _posts[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.purple[100],
                                      backgroundImage: post.creatorPhotoUrl !=
                                              null
                                          ? NetworkImage(post.creatorPhotoUrl!)
                                          : null,
                                      child: post.creatorPhotoUrl == null
                                          ? const Icon(Icons.person)
                                          : null,
                                    ),
                                    title: Text(post.creatorName),
                                    subtitle: Text(post.timeAgo),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.more_vert),
                                      onPressed: () {},
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          post.title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          post.content,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (post.imageUrl != null)
                                    Container(
                                      height: 200,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(post.imageUrl!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  else
                                    Container(
                                      height: 200,
                                      color: Colors.purple[50],
                                      child: Center(
                                        child: Icon(
                                          Icons.image,
                                          size: 64,
                                          color: Colors.purple[200],
                                        ),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                post.likes.contains(
                                                        _currentUser?.uid)
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: Colors.purple[300],
                                              ),
                                              onPressed: () =>
                                                  _toggleLike(post),
                                            ),
                                            Text(
                                              post.likes.length.toString(),
                                              style: TextStyle(
                                                  color: Colors.purple[300]),
                                            ),
                                          ],
                                        ),
                                        if (_currentUser?.subscriptionTier !=
                                                'inner' &&
                                            post.accessTier == 'inner')
                                          TextButton.icon(
                                            icon: const Icon(Icons.lock),
                                            label: const Text(
                                                'Unlock Full Content'),
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, '/tier_list');
                                            },
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
          // Notifications
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No new notifications',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          // Profile placeholder (redirects to tier list)
          const SizedBox(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF9146FF),
        onTap: _onItemTapped,
      ),
    );
  }
}
