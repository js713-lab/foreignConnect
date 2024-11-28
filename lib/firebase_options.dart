import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyC0b0qQEKUosWWP3UyKkeiqhbUNRJbKQOI',
    appId: '1:260778926337:web:5ef4edc2447bcc03adfb00',
    messagingSenderId: '260778926337',
    projectId: 'foreignconnect-76d91',
    authDomain: 'foreignconnect-76d91.firebaseapp.com',
    storageBucket: 'foreignconnect-76d91.firebasestorage.app',
    measurementId: 'G-QT318V5RG3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBvNwQpkyxqho-SUgH3TjN7FWVt_yfC05E',
    appId: '1:260778926337:android:ebd5b0a0ee9cc53aadfb00',
    messagingSenderId: '260778926337',
    projectId: 'foreignconnect-76d91',
    storageBucket: 'foreignconnect-76d91.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBQF2VRpOWp2j8s7bpSF8Ng5Z0ll7Q0rZg',
    appId: '1:260778926337:ios:11d3c23453fbce73adfb00',
    messagingSenderId: '260778926337',
    projectId: 'foreignconnect-76d91',
    storageBucket: 'foreignconnect-76d91.firebasestorage.app',
    iosBundleId: 'com.example.foreignConnect',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBQF2VRpOWp2j8s7bpSF8Ng5Z0ll7Q0rZg',
    appId: '1:260778926337:ios:11d3c23453fbce73adfb00',
    messagingSenderId: '260778926337',
    projectId: 'foreignconnect-76d91',
    storageBucket: 'foreignconnect-76d91.firebasestorage.app',
    iosBundleId: 'com.example.foreignConnect',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC0b0qQEKUosWWP3UyKkeiqhbUNRJbKQOI',
    appId: '1:260778926337:web:c8e8b12952e982b9adfb00',
    messagingSenderId: '260778926337',
    projectId: 'foreignconnect-76d91',
    authDomain: 'foreignconnect-76d91.firebaseapp.com',
    storageBucket: 'foreignconnect-76d91.firebasestorage.app',
    measurementId: 'G-DRFF5NQ7Y9',
  );
}
