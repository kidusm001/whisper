import 'package:flutter/material.dart';
import 'package:whisper/features/profile/screens/profile_screen.dart';
import 'package:whisper/features/services/social_service.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  const HomeScreen({
    super.key,
    required this.toggleTheme,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool _isSidebarVisible = false;
  final bool _isDarkMode = false;
  bool _isSearchExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  final SocialService _socialService = SocialService();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarVisible = !_isSidebarVisible;
      if (_isSidebarVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  // Public method to toggle the sidebar
  void toggleSidebar() {
    _toggleSidebar();
  }

  Future<void> _followUser(String userId) async {
    bool success = await _socialService.followUser('currentUserId', userId);
    if (success) {
      // Update UI or show a message
    }
  }

  Future<void> _unfollowUser(String userId) async {
    bool success = await _socialService.unfollowUser('currentUserId', userId);
    if (success) {
      // Update UI or show a message
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Row(
        children: [
          Expanded(child: _buildMainFeed()),
          if (MediaQuery.of(context).size.width > 1200) _buildRightSidebar(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final theme = Theme.of(context);
    if (_isSearchExpanded) {
      return AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.menu, color: theme.iconTheme.color),
          onPressed: _toggleSidebar,
        ),
        title: TextField(
          autofocus: true,
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: 'Search posts or creators...',
            hintStyle:
                theme.textTheme.bodyLarge?.copyWith(color: theme.hintColor),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: theme.iconTheme.color),
            onPressed: () {
              setState(() {
                _isSearchExpanded = false;
              });
            },
          ),
        ],
      );
    }

    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 1,
      leading: IconButton(
        icon: Icon(Icons.menu, color: theme.iconTheme.color),
        onPressed: _toggleSidebar,
      ),
      title: const Text('Whisper'),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            setState(() {
              _isSearchExpanded = true;
            });
          },
        ),
        if (!_isSearchExpanded) ...[
          IconButton(
            icon: Icon(Icons.notifications_outlined,
                color: theme.iconTheme.color),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          PopupMenuButton(
            offset: const Offset(0, 45),
            child: const CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage('https://placeholder.com/150x150'),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileScreen()),
                    );
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.card_membership),
                  title: const Text('Subscription Plans'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/subscription-tiers');
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(
                    Theme.of(context).brightness == Brightness.light
                        ? Icons.dark_mode
                        : Icons.light_mode,
                  ),
                  title: Text(Theme.of(context).brightness == Brightness.light
                      ? 'Dark Mode'
                      : 'Light Mode'),
                  onTap: () {
                    Navigator.pop(context);
                    widget.toggleTheme();
                  },
                ),
              ),
              const PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                ),
              ),
              const PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
        ],
      ],
    );
  }

  Widget _buildMainFeed() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) => _buildPostCard(),
    );
  }

  Widget _buildPostCard() {
    return PostCard(toggleTheme: widget.toggleTheme, followUser: _followUser);
  }

  Widget _buildRightSidebar() {
    final theme = Theme.of(context);
    return Container(
      width: 300,
      color: theme.scaffoldBackgroundColor,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trending Creators',
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Add trending creators list here
          Text(
            'Upcoming Events',
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Add events list here
        ],
      ),
    );
  }
}

class PostCard extends StatefulWidget {
  final VoidCallback toggleTheme;
  final Future<void> Function(String) followUser;

  const PostCard({
    super.key,
    required this.toggleTheme,
    required this.followUser,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isLiked = false;
  int _likeCount = 0;
  int _commentCount = 0;

  @override
  void initState() {
    super.initState();
    // Initialize like count and comment count from data source
    _likeCount = 10; // Example value
    _commentCount = 5; // Example value
  }

  Future<void> _toggleLike() async {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });
    // Call social service to like/unlike post
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundImage: NetworkImage('https://placeholder.com/50x50'),
            ),
            title: Text(
              'Creator Name',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Premium Member',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.person_add, color: theme.iconTheme.color),
              onPressed: () => widget.followUser('userId'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Post Title Goes Here',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This is a preview of the post content. Click to read more...',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Media Content',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(color: theme.dividerColor),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    _isLiked ? Icons.favorite : Icons.favorite_border,
                    color: theme.iconTheme.color,
                  ),
                  onPressed: _toggleLike,
                ),
                Text('$_likeCount Likes'),
                IconButton(
                  icon: Icon(Icons.comment_outlined,
                      color: theme.iconTheme.color),
                  onPressed: () {
                    // Navigate to comment screen
                  },
                ),
                Text('$_commentCount Comments'),
                IconButton(
                  icon: Icon(Icons.share, color: theme.iconTheme.color),
                  onPressed: () {},
                ),
                IconButton(
                  icon:
                      Icon(Icons.bookmark_border, color: theme.iconTheme.color),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
