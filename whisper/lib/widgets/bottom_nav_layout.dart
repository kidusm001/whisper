import 'package:flutter/material.dart';
import 'package:whisper/features/profile/screens/create_post_screen.dart'; // Updated import
import 'package:whisper/screen/home_screen.dart';
import 'package:whisper/features/explore/screens/explore_screen.dart';

class BottomNavLayout extends StatefulWidget {
  const BottomNavLayout({super.key});

  @override
  State<BottomNavLayout> createState() => _BottomNavLayoutState();
}

class _BottomNavLayoutState extends State<BottomNavLayout> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(), // Removed 'const'
    HomeScreen(), // Dummy for center button, removed 'const'
    const ExploreScreen(), // Removed 'const'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomAppBar(
          height: 65, // Increased height
          notchMargin: 8,
          padding: const EdgeInsets.symmetric(horizontal: 8), // Added padding
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8), // Added top padding
                child:
                    _buildNavItem(0, Icons.home_outlined, Icons.home, 'Home'),
              ),
              const SizedBox(width: 60), // Space for FAB
              Padding(
                padding: const EdgeInsets.only(top: 8), // Added top padding
                child: _buildNavItem(
                    2, Icons.explore_outlined, Icons.explore, 'Explore'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        height: 65,
        width: 65,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreatePostScreen()),
            );
          },
          backgroundColor: const Color(0xFF320064),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
          child: const Icon(
            Icons.add,
            size: 35,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildNavItem(
      int index, IconData outlinedIcon, IconData filledIcon, String label) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: SizedBox(
        // Added fixed size container
        width: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? filledIcon : outlinedIcon,
              color: isSelected ? const Color(0xFF320064) : Colors.grey,
              size: 26, // Slightly reduced icon size
            ),
            const SizedBox(height: 2), // Reduced spacing
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF320064) : Colors.grey,
                fontSize: 11, // Slightly reduced font size
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
