import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Supabase: provide your Supabase URL and anon key.
  await Supabase.initialize(
    url:
        'https://qpimyiyumhuvgmgvcntx.supabase.co', // Replace with your Supabase URL
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFwaW15aXl1bWh1dmdtZ3ZjbnR4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg3NjUyNDEsImV4cCI6MjA1NDM0MTI0MX0.ajWEwW61x4hZK-8kv0kSuDuoSiHW5-ZgiIXSff1zlWY', // Replace with your Supabase anon (public) key
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whisper',
      home: Scaffold(
        appBar: AppBar(title: const Text('Whisper')),
        body: const Center(child: Text('Welcome to Whisper!')),
      ),
    );
  }
}
