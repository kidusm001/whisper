import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/features/auth/providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whisper/data/models/user_model.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _displayName = '';
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Call the signUpWithEmail method from AuthService.
      final authService = ref.read(authServiceProvider);
      final userCredential =
          await authService.signUpWithEmail(email: _email, password: _password);

      // Create a new AppUser from the model.
      final newUser = AppUser(
        uid: userCredential.user!.uid,
        email: _email,
        displayName: _displayName,
        joinDate: DateTime.now(),
      );

      // Save the user to Firestore.
      await FirebaseFirestore.instance
          .collection('users')
          .doc(newUser.uid)
          .set(newUser.toJson());

      // Navigate or update UI as needed.
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Display Name'),
                onSaved: (value) => _displayName = value!.trim(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a display name.';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => _email = value!.trim(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email.';
                  }
                  if (!value.contains('@')) {
                    return 'Enter a valid email address.';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onSaved: (value) => _password = value!.trim(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password.';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _signUp,
                      child: const Text('Sign Up'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
