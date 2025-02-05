import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final AuthService _authService;
  UserModel? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeAuthService();
  }

  Future<void> _initializeAuthService() async {
    _authService = AuthService(await SharedPreferences.getInstance());
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await _authService.getCurrentUser();
      if (mounted) {
        setState(() {
          _user = user;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error loading user data')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Implement settings
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _user == null
              ? const Center(child: Text('Error loading profile'))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: AppGradients.primaryGradient,
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              backgroundImage: _user?.photoUrl != null
                                  ? NetworkImage(_user!.photoUrl!)
                                  : null,
                              child: _user?.photoUrl == null
                                  ? const Icon(Icons.person, size: 50)
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _user?.displayName ?? 'Anonymous',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _user?.email ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ListTile(
                        leading: const Icon(Icons.star),
                        title: const Text('Subscription Status'),
                        subtitle: Text(
                          _user?.subscriptionTier == 'none'
                              ? 'No active subscription'
                              : 'Active: ${_user?.subscriptionTier ?? ''} tier',
                        ),
                        trailing: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/tier_list');
                          },
                          child: Text(
                            _user?.subscriptionTier == 'none'
                                ? 'Subscribe'
                                : 'Manage',
                          ),
                        ),
                      ),
                      if (_user?.isCreator == true) ...[
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.create),
                          title: const Text('Create Post'),
                          onTap: () {
                            Navigator.pushNamed(context, '/create_post');
                          },
                        ),
                      ],
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.people),
                        title: const Text('Following'),
                        subtitle: Text(
                          '${_user?.following.length ?? 0} creators',
                        ),
                        onTap: () {
                          // TODO: Implement following list
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.edit),
                        title: const Text('Edit Profile'),
                        onTap: () {
                          // TODO: Implement edit profile
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: () async {
                          try {
                            await _authService.logout();
                            if (mounted) {
                              Navigator.pushReplacementNamed(context, '/login');
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Error logging out'),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
    );
  }
}
