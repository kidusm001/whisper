import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/providers/auth_provider.dart'; // Adjust the import path as needed
import 'features/auth/login_screen.dart';
import 'features/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Supabase: provide your Supabase URL and anon key.
  await Supabase.initialize(
    url: 'https://qpimyiyumhuvgmgvcntx.supabase.co', // Your Supabase URL.
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFwaW15aXl1bWh1dmdtZ3ZjbnR4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg3NjUyNDEsImV4cCI6MjA1NDM0MTI0MX0.ajWEwW61x4hZK-8kv0kSuDuoSiHW5-ZgiIXSff1zlWY', // Your Supabase anon (public) key.
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to the authentication state using authStateProvider from auth_provider.dart.
    final authState = ref.watch(authStateProvider);
    return MaterialApp(
      title: 'Whisper',
      home: authState.when(
        data: (user) => user != null ? const HomeScreen() : const LoginScreen(),
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (error, stack) => Scaffold(
          body: Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}
