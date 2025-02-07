import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_screen.dart';
import 'messages_screen.dart';
import 'membership_screen.dart';
import 'saved_posts_screen.dart';
import 'explore_creators_screen.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  final VoidCallback toggleTheme;
  const MainNavigationScreen({super.key, required this.toggleTheme});

  @override
  ConsumerState<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  int _selectedIndex = 0;
  List<Widget> _screens = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSearching = false;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(toggleTheme: widget.toggleTheme),
      const ExploreCreatorsScreen(),
      const MessagesScreen(),
      const MembershipScreen(),
      const SavedPostsScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.pop(context);
    }
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return false;
    }
    return true;
  }

  Future<void> _handleLogout() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error logging out: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
          title: _isSearching
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  ),
                  style: Theme.of(context).textTheme.bodyLarge,
                )
              : Text(_getScreenTitle()),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(_isSearching ? Icons.close : Icons.search),
              onPressed: () {
                setState(() {
                  if (_isSearching) {
                    _searchController.clear();
                  }
                  _isSearching = !_isSearching;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/profile'),
                child: const CircleAvatar(
                  radius: 16,
                  backgroundImage:
                      NetworkImage('https://placeholder.com/150x150'),
                ),
              ),
            ),
          ],
        ),
        drawer: Drawer(
          width: 210,
          child: Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: const Icon(Icons.person,
                          size: 30, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'User Name',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(8.0),
                  children: [
                    _buildDrawerItem(icon: Icons.home, title: 'Home', index: 0),
                    _buildDrawerItem(
                        icon: Icons.explore, title: 'Explore', index: 1),
                    _buildDrawerItem(
                        icon: Icons.message, title: 'Messages', index: 2),
                    _buildDrawerItem(
                        icon: Icons.group, title: 'Memberships', index: 3),
                    _buildDrawerItem(
                        icon: Icons.bookmark, title: 'Saved', index: 4),
                    const Divider(),
                    ListTile(
                      leading:
                          Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
                      title: Text('${isDarkMode ? "Light" : "Dark"} Mode'),
                      onTap: widget.toggleTheme,
                    ),
                  ],
                ),
              ),
              const Divider(height: 0),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title:
                    const Text('Logout', style: TextStyle(color: Colors.red)),
                onTap: _handleLogout,
              ),
            ],
          ),
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore),
              label: 'Explore',
            ),
            NavigationDestination(
              icon: Icon(Icons.message_outlined),
              selectedIcon: Icon(Icons.message),
              label: 'Messages',
            ),
            NavigationDestination(
              icon: Icon(Icons.card_membership_outlined),
              selectedIcon: Icon(Icons.card_membership),
              label: 'Memberships',
            ),
            NavigationDestination(
              icon: Icon(Icons.bookmark_outline),
              selectedIcon: Icon(Icons.bookmark),
              label: 'Saved',
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required int index,
  }) {
    final isSelected = index == _selectedIndex;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final selectedColor = isDarkMode
        ? const Color(0xFF9D6FFF) // Light purple for dark mode
        : const Color(0xFF320064); // Dark purple for light mode

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: selectedColor.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        leading: Icon(
          icon,
          color: isSelected ? selectedColor : null,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? selectedColor : null,
            fontWeight: isSelected ? FontWeight.bold : null,
          ),
        ),
        selected: isSelected,
        selectedTileColor: selectedColor.withOpacity(0.1),
        onTap: () => _onItemTapped(index),
      ),
    );
  }

  String _getScreenTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Home';
      case 1:
        return 'Explore Creators';
      case 2:
        return 'Messages';
      case 3:
        return 'Memberships';
      case 4:
        return 'Saved Posts';
      default:
        return '';
    }
  }
}
