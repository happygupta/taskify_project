// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyCzqxFEAuyGgzCMIEdb22iLwcrCgykmWx4',
    appId: '1:18642625755:web:83890323f93f75f3af58fe',
    messagingSenderId: '18642625755',
    projectId: 'testing-8ba69',
    authDomain: 'testing-8ba69.firebaseapp.com',
    storageBucket: 'testing-8ba69.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDOGh9bJU1ulzRGyziwCFw_XoUkOCaMJt0',
    appId: '1:18642625755:android:3a4428a5af47e54aaf58fe',
    messagingSenderId: '18642625755',
    projectId: 'testing-8ba69',
    storageBucket: 'testing-8ba69.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAIOjqy6P7hkBPq1kIGKDqhAoZgfMFAnFU',
    appId: '1:1064992372008:ios:775206fd255aab54394c1d',
    messagingSenderId: '1064992372008',
    projectId: 'taskify-ebec8',
    storageBucket: 'taskify-ebec8.firebasestorage.app',
    iosBundleId: 'com.example.taskifyProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAIOjqy6P7hkBPq1kIGKDqhAoZgfMFAnFU',
    appId: '1:1064992372008:ios:775206fd255aab54394c1d',
    messagingSenderId: '1064992372008',
    projectId: 'taskify-ebec8',
    storageBucket: 'taskify-ebec8.firebasestorage.app',
    iosBundleId: 'com.example.taskifyProject',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC-zP3wifZGH8x7OsKQg-APkv7Q6ABjF4A',
    appId: '1:1064992372008:web:10ef7eb95cc96903394c1d',
    messagingSenderId: '1064992372008',
    projectId: 'taskify-ebec8',
    authDomain: 'taskify-ebec8.firebaseapp.com',
    storageBucket: 'taskify-ebec8.firebasestorage.app',
    measurementId: 'G-W5Z7L13898',
  );

}