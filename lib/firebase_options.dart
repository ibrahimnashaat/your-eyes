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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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


  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA2e_BzBNaDBPfFTij4Z1oJRrJIna2oVIc',
    appId: '1:497217759351:android:650002300dfb59f7397e72',
    messagingSenderId: '497217759351',
    projectId: 'your-eyes-d45ae',
    storageBucket: 'your-eyes-d45ae.appspot.com',
    iosBundleId: 'com.example.yourEyes',
  );






  static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'AIzaSyA2e_BzBNaDBPfFTij4Z1oJRrJIna2oVIc',
  appId: '1:497217759351:android:650002300dfb59f7397e72',
  messagingSenderId: '497217759351',
  projectId: 'your-eyes-d45ae',
  storageBucket: 'your-eyes-d45ae.appspot.com',
  );




}
