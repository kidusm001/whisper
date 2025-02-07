import 'package:flutter/material.dart';
import 'package:whisper/widgets/universal_app_bar.dart';
import 'package:whisper/widgets/universal_drawer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // <-- New GlobalKey

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // <-- Assign key to Scaffold
      appBar: UniversalAppBar(
        title: 'Whisper',
        onMenuPressed: () {
          _scaffoldKey.currentState?.openDrawer(); // <-- Use key to open drawer
        },
      ),
      drawer: const UniversalDrawer(),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10,
        itemBuilder: (context, index) =>
            _buildPostCard(context), // pass context
      ),
    );
  }

  Widget _buildPostCard(BuildContext context) {
    return Card(
      // Remove or update hardcoded background color to use theme
      // color: Colors.white,
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
            // Let the text style inherit the theme (remove explicit colors)
            title: Text(
              'Creator Name',
              // style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Premium Member',
              // style: TextStyle(color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Post Title Goes Here',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'This is a preview of the post content. Click to read more...',
                  style: Theme.of(context).textTheme.bodyMedium,
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
                  icon: const Icon(Icons.favorite_border),
                  color: Theme.of(context).iconTheme.color, // Use themed color
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.comment_outlined),
                  color: Theme.of(context).iconTheme.color,
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  color: Theme.of(context).iconTheme.color,
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.bookmark_border),
                  color: Theme.of(context).iconTheme.color,
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
