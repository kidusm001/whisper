import 'package:flutter/material.dart';
import 'package:whisper/features/profile/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool _isSidebarVisible = false;
  bool _isDarkMode = false;
  bool _isSearchExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.grey[100],
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Row(
            children: [
              Expanded(child: _buildMainFeed()),
              if (MediaQuery.of(context).size.width > 1200) _buildRightSidebar(),
            ],
          ),
          if (_isSidebarVisible) 
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return GestureDetector(
                  onTap: _toggleSidebar,
                  child: Container(
                    color: Colors.black.withOpacity(0.5 * _animation.value),
                  ),
                );
              },
            ),
          if (_isSidebarVisible) 
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1, 0),
                end: Offset.zero,
              ).animate(_animation),
              child: _buildLeftSidebar(),
            ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    if (_isSearchExpanded) {
      return AppBar(
        backgroundColor: _isDarkMode ? Colors.grey[850] : Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: _toggleSidebar,
        ),
        title: const TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search posts or creators...',
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
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
      backgroundColor: _isDarkMode ? Colors.grey[850] : Colors.white,
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: _toggleSidebar,
      ),
      title: const Text(
        "Whisper",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
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
            icon: const Icon(Icons.notifications_outlined),
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
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(
                    _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  ),
                  title: Text(_isDarkMode ? 'Light Mode' : 'Dark Mode'),
                  onTap: () {
                    setState(() => _isDarkMode = !_isDarkMode);
                    Navigator.pop(context);
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

  Widget _buildLeftSidebar() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: MediaQuery.of(context).size.height,
      color: _isDarkMode ? Colors.grey[850] : Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage('https://placeholder.com/150x150'),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User Name',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('Premium Member'),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _toggleSidebar,
                ),
              ],
            ),
          ),
          const Divider(),
          _buildSidebarItem(Icons.home, 'Home', isSelected: true),
          _buildSidebarItem(Icons.message, 'Messages'),
          _buildSidebarItem(Icons.group, 'My Memberships'),
          _buildSidebarItem(Icons.bookmark, 'Saved Posts'),
          _buildSidebarItem(Icons.explore, 'Explore Creators'),
          const Spacer(),
          const Divider(),
          _buildSidebarItem(Icons.logout, 'Logout'),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String label, {bool isSelected = false}) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.blue : null),
      title: Text(label),
      selected: isSelected,
      onTap: () {},
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
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage('https://placeholder.com/50x50'),
            ),
            title: Text(
              'Creator Name',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Premium Member',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Post Title Goes Here',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'This is a preview of the post content. Click to read more...',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Media Content',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(color: Colors.grey[300]),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.black),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.comment_outlined, color: Colors.black),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.black),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.bookmark_border, color: Colors.black),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightSidebar() {
    return Container(
      width: 300,
      color: _isDarkMode ? Colors.grey[850] : Colors.white,
      padding: const EdgeInsets.all(16),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trending Creators',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          // Add trending creators list here
          Text(
            'Upcoming Events',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          // Add events list here
        ],
      ),
    );
  }
}
