// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAtLh3uAbR8Whcg_sM-KqB6ZztSXh-BsbM',
    appId: '1:1013882809024:web:ac8e11229e6a9b29245b25',
    messagingSenderId: '1013882809024',
    projectId: 'whisper-d6b77',
    authDomain: 'whisper-d6b77.firebaseapp.com',
    storageBucket: 'whisper-d6b77.firebasestorage.app',
    measurementId: 'G-W71JSRH8NV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAaFg0CbwNnLhmavxafrKCmUlVenbqUoYY',
    appId: '1:1013882809024:android:2006361231deb09e245b25',
    messagingSenderId: '1013882809024',
    projectId: 'whisper-d6b77',
    storageBucket: 'whisper-d6b77.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDAtrPMHXXQhbx0ri99f1Znpa_EKH7S2QM',
    appId: '1:1013882809024:ios:f2475cefc98fb264245b25',
    messagingSenderId: '1013882809024',
    projectId: 'whisper-d6b77',
    storageBucket: 'whisper-d6b77.firebasestorage.app',
    iosBundleId: 'com.whisperapp.whisper',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDAtrPMHXXQhbx0ri99f1Znpa_EKH7S2QM',
    appId: '1:1013882809024:ios:f2475cefc98fb264245b25',
    messagingSenderId: '1013882809024',
    projectId: 'whisper-d6b77',
    storageBucket: 'whisper-d6b77.firebasestorage.app',
    iosBundleId: 'com.whisperapp.whisper',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAtLh3uAbR8Whcg_sM-KqB6ZztSXh-BsbM',
    appId: '1:1013882809024:web:b3a8d5e82cada118245b25',
    messagingSenderId: '1013882809024',
    projectId: 'whisper-d6b77',
    authDomain: 'whisper-d6b77.firebaseapp.com',
    storageBucket: 'whisper-d6b77.firebasestorage.app',
    measurementId: 'G-R3J58046TE',
  );
}
