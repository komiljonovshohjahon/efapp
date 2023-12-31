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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDzaBrhlH-1kJ-4PlNqfy08C9eKA8l6G08',
    appId: '1:1017296850809:web:fee374b016663cbe62e9a8',
    messagingSenderId: '1017296850809',
    projectId: 'francis-c34ff',
    authDomain: 'francis-c34ff.firebaseapp.com',
    databaseURL: 'https://francis-c34ff.firebaseio.com',
    storageBucket: 'francis-c34ff.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAcqI1Hxvcu1TPqQHV32U9J9ruMSWHNku0',
    appId: '1:1017296850809:android:fab1026ee34fe7f362e9a8',
    messagingSenderId: '1017296850809',
    projectId: 'francis-c34ff',
    databaseURL: 'https://francis-c34ff.firebaseio.com',
    storageBucket: 'francis-c34ff.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB_CZ5UbAFtRbrwJcd15CKj6FOlMLoQxV4',
    appId: '1:1017296850809:ios:efb11c3bf39b71d762e9a8',
    messagingSenderId: '1017296850809',
    projectId: 'francis-c34ff',
    databaseURL: 'https://francis-c34ff.firebaseio.com',
    storageBucket: 'francis-c34ff.appspot.com',
    iosClientId: '1017296850809-604n5aupq9iuibpgr88agub8sp8i1e3a.apps.googleusercontent.com',
    iosBundleId: 'com.christianappdevelopers.efapp.efapp',
  );
}
