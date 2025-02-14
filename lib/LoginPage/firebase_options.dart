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
    apiKey: 'AIzaSyAmt-_gqFx7TOoomVgONkJClliPTYNpPgw',
    appId: '1:1029501106810:web:1163cc98490e2183eb19c3',
    messagingSenderId: '1029501106810',
    projectId: 'soulee-database',
    authDomain: 'soulee-database.firebaseapp.com',
    storageBucket: 'soulee-database.appspot.com',
    measurementId: 'G-H8XF5VWXY9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDvVk17aqGDPLVj-Qkif15FDEqi5FFBoDU',
    appId: '1:1029501106810:android:5c9b1de7919b5808eb19c3',
    messagingSenderId: '1029501106810',
    projectId: 'soulee-database',
    storageBucket: 'soulee-database.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBHV0sSTc0jBJBhP1ZH_TDttnvTohL5qsE',
    appId: '1:1029501106810:ios:20c0784906258ab6eb19c3',
    messagingSenderId: '1029501106810',
    projectId: 'soulee-database',
    storageBucket: 'soulee-database.appspot.com',
    iosBundleId: 'com.example.loginpage',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBHV0sSTc0jBJBhP1ZH_TDttnvTohL5qsE',
    appId: '1:1029501106810:ios:20c0784906258ab6eb19c3',
    messagingSenderId: '1029501106810',
    projectId: 'soulee-database',
    storageBucket: 'soulee-database.appspot.com',
    iosBundleId: 'com.example.loginpage',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAmt-_gqFx7TOoomVgONkJClliPTYNpPgw',
    appId: '1:1029501106810:web:d5b82118b788bb1eeb19c3',
    messagingSenderId: '1029501106810',
    projectId: 'soulee-database',
    authDomain: 'soulee-database.firebaseapp.com',
    storageBucket: 'soulee-database.appspot.com',
    measurementId: 'G-2N3DNGZ7C2',
  );
}
