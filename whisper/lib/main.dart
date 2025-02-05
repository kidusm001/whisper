import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme.dart';
import 'pages/login/login_page.dart';
import 'pages/main/main_page.dart';
import 'pages/tier_list/tier_list_page.dart';
import 'pages/profile/profile_page.dart';
import 'pages/create_post/create_post_page.dart';
import 'pages/notifications/notifications_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whisper',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/': (context) => const LoginPage(),
        '/login': (context) => const LoginPage(),
        '/main': (context) => const MainPage(),
        '/tier_list': (context) => const TierListPage(),
        '/profile': (context) => const ProfilePage(),
        '/create_post': (context) => const CreatePostPage(),
        '/notifications': (context) => const NotificationsPage(),
      },
    );
  }
}
