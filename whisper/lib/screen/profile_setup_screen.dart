import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whisper/features/models/user_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _bioController = TextEditingController();
  
  // Platform-specific image storage
  File? _profileImage;
  File? _coverImage;
  Uint8List? _profileImageWeb;
  Uint8List? _coverImageWeb;
  
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source, String type) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          if (type == 'profile') {
            _profileImageWeb = bytes;
            _profileImage = null; // Clear other format
          } else {
            _coverImageWeb = bytes;
            _coverImage = null; // Clear other format
          }
        });
      } else {
        setState(() {
          if (type == 'profile') {
            _profileImage = File(pickedFile.path);
            _profileImageWeb = null; // Clear other format
          } else {
            _coverImage = File(pickedFile.path);
            _coverImageWeb = null; // Clear other format
          }
        });
      }
    }
  }

  Future<String?> _uploadImageToSupabase(
      dynamic imageFile,
      String imageType,
      String userId) async {
    if (imageFile == null) return null;
    
    final supabaseClient = Supabase.instance.client;
    final fileName =
        '${userId}_${imageType}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final imagePath = '$userId/$imageType/$fileName';

    debugPrint("Uploading to path: $imagePath");
    debugPrint("Current User UID (from FirebaseAuth): ${FirebaseAuth.instance.currentUser?.uid}");

    try {
      if (imageFile is Uint8List) {
        await supabaseClient.storage.from('images').uploadBinary(
              imagePath,
              imageFile,
              fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
            );
      } else if (imageFile is File) {
        await supabaseClient.storage.from('images').upload(
              imagePath,
              imageFile,
              fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
            );
      } else {
        throw Exception('Unsupported image file type');
      }

      final publicUrl =
          supabaseClient.storage.from('images').getPublicUrl(imagePath);
      return publicUrl;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: $e')),
        );
      }
      return null;
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser!;

      // Handle profile image upload
      String? profileUrl;
      if (kIsWeb && _profileImageWeb != null) {
        profileUrl = await _uploadImageToSupabase(_profileImageWeb, 'profile', user.uid);
      } else if (!kIsWeb && _profileImage != null) {
        profileUrl = await _uploadImageToSupabase(_profileImage, 'profile', user.uid);
      }

      // Handle cover image upload
      String? coverUrl;
      if (kIsWeb && _coverImageWeb != null) {
        coverUrl = await _uploadImageToSupabase(_coverImageWeb, 'cover', user.uid);
      } else if (!kIsWeb && _coverImage != null) {
        coverUrl = await _uploadImageToSupabase(_coverImage, 'cover', user.uid);
      }

      final userModel = UserModel(
        uid: user.uid,
        email: user.email!,
        displayName: _displayNameController.text.trim(),
        bio: _bioController.text.trim(),
        photoUrl: profileUrl,
        coverImage: coverUrl,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(userModel.toJson(), SetOptions(merge: true));

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      debugPrint('Error saving profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving profile: $e')),
        );
      }
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
      appBar: AppBar(
        title: const Text('Set Up Your Profile'),
        backgroundColor: const Color(0xFF320064),
      ),
      backgroundColor: const Color(0xFF000000),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () => _pickImage(ImageSource.gallery, 'profile'),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[700],
                  backgroundImage: kIsWeb
                      ? (_profileImageWeb != null ? MemoryImage(_profileImageWeb!) : null)
                      : (_profileImage != null ? FileImage(_profileImage!) : null) as ImageProvider?,
                  child: _profileImage == null && _profileImageWeb == null
                      ? const Icon(Icons.camera_alt, size: 40)
                      : null,
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () => _pickImage(ImageSource.gallery, 'profile'),
                  child: const Text('Select Profile Picture',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => _pickImage(ImageSource.gallery, 'cover'),
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    image: _coverImage != null || _coverImageWeb != null
                        ? DecorationImage(
                            image: kIsWeb
                                ? (_coverImageWeb != null
                                    ? MemoryImage(_coverImageWeb!)
                                    : const AssetImage('assets/placeholder.png'))
                                : (_coverImage != null
                                    ? FileImage(_coverImage!)
                                    : const AssetImage('assets/placeholder.png')) as ImageProvider,
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _coverImage == null && _coverImageWeb == null
                      ? const Icon(Icons.camera_alt, size: 40)
                      : null,
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () => _pickImage(ImageSource.gallery, 'cover'),
                  child: const Text('Select Cover Image',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _displayNameController,
                style: const TextStyle(color: Colors.white),
                decoration: _buildInputDecoration('Display Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your display name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bioController,
                style: const TextStyle(color: Colors.white),
                decoration: _buildInputDecoration('Bio'),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF320064)),
                    )
                  : ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF320064),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Save Profile'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF320064)),
      ),
      filled: true,
      fillColor: const Color(0xFF282828),
    );
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}
