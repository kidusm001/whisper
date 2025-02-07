import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/signup_screen.dart';
import 'screen/home_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screen/profile_setup_screen.dart';
import 'screen/subscription_tiers_screen.dart';
import 'screen/main_navigation_screen.dart';
import 'features/profile/screens/create_post_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ljwwgbouaqnejyatmkye.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imxqd3dnYm91YXFuZWp5YXRta3llIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg3OTY4NzcsImV4cCI6MjA1NDM3Mjg3N30.j2cj4kDZj53exoS2bVmb36IQgWnmSNAPtlyH2f_nk7k',
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void toggleTheme() {
    setState(() {
      print('Current themeMode: $_themeMode');
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
      print('New themeMode: $_themeMode');
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Whisper',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: Colors.white,
          cardColor: Colors.white,
          textTheme: const TextTheme().apply(
            bodyColor: Colors.black,
            displayColor: Colors.black,
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          dividerColor: Colors.grey[300],
          hintColor: Colors.grey[600],
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: Colors.black,
          cardColor: const Color(0xFF1E1E1E),
          textTheme: const TextTheme().apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          dividerColor: Colors.grey[800],
          hintColor: Colors.grey[400],
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          useMaterial3: true,
        ),
        themeMode: _themeMode,
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(),
          '/home': (context) => HomeScreen(toggleTheme: toggleTheme),
          '/profile-setup': (context) => const ProfileSetupScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/subscription-tiers': (context) => const SubscriptionTiersScreen(),
          '/main-navigation': (context) =>
              MainNavigationScreen(toggleTheme: toggleTheme),
          '/create-post': (context) => const CreatePostScreen(),
        },
      ),
    );
  }
}
