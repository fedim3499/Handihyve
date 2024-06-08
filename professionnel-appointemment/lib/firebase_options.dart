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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCsw6cHtIOHmfE8nGkibLXaxquuvd9P94I',
    appId: '1:655373946863:web:10b46d0b0d41a8561e301a',
    messagingSenderId: '655373946863',
    projectId: 'handihive-f78ae',
    authDomain: 'handihive-f78ae.firebaseapp.com',
    storageBucket: 'handihive-f78ae.appspot.com',
    measurementId: 'G-QYD7GKYQQ2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDeHk6cuKIbLVgzcebmDySUX1ga-zaPTyE',
    appId: '1:655373946863:android:a707a4326dca864c1e301a',
    messagingSenderId: '655373946863',
    projectId: 'handihive-f78ae',
    storageBucket: 'handihive-f78ae.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDBfuiDicVQILvilBiPkW572Tx0cVP2q4Q',
    appId: '1:655373946863:ios:005a0b3effd405121e301a',
    messagingSenderId: '655373946863',
    projectId: 'handihive-f78ae',
    storageBucket: 'handihive-f78ae.appspot.com',
    iosBundleId: 'com.example.profession',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCsw6cHtIOHmfE8nGkibLXaxquuvd9P94I',
    appId: '1:655373946863:web:17f471df31a845ef1e301a',
    messagingSenderId: '655373946863',
    projectId: 'handihive-f78ae',
    authDomain: 'handihive-f78ae.firebaseapp.com',
    storageBucket: 'handihive-f78ae.appspot.com',
    measurementId: 'G-74HMJFN9W6',
  );
}