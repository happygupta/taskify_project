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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAFZclufZ8252HUGc0ReoC-naQAgSn2mZU',
    appId: '1:887469627935:web:3740d53a80236b697d932a',
    messagingSenderId: '887469627935',
    projectId: 'taskify-6b0cb',
    authDomain: 'taskify-6b0cb.firebaseapp.com',
    storageBucket: 'taskify-6b0cb.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBDoKW7NJRMvr5NuMDgdPI0GA9hzLpzdDs',
    appId: '1:887469627935:android:1ac08e421259bd827d932a',
    messagingSenderId: '887469627935',
    projectId: 'taskify-6b0cb',
    storageBucket: 'taskify-6b0cb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBT-OFlOK_sv5awD5-IXHxfBhrjpR5sWgY',
    appId: '1:887469627935:ios:42832c743d5526a07d932a',
    messagingSenderId: '887469627935',
    projectId: 'taskify-6b0cb',
    storageBucket: 'taskify-6b0cb.appspot.com',
    iosClientId: '887469627935-ifmmavedup5961qoclnm542902958trh.apps.googleusercontent.com',
    iosBundleId: 'com.example.taskifyProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBT-OFlOK_sv5awD5-IXHxfBhrjpR5sWgY',
    appId: '1:887469627935:ios:42832c743d5526a07d932a',
    messagingSenderId: '887469627935',
    projectId: 'taskify-6b0cb',
    storageBucket: 'taskify-6b0cb.appspot.com',
    iosClientId: '887469627935-ifmmavedup5961qoclnm542902958trh.apps.googleusercontent.com',
    iosBundleId: 'com.example.taskifyProject',
  );
}