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
    apiKey: 'AIzaSyBqqZUFk4UE2c25GCulSNBW2BnJWbKysX0',
    appId: '1:230440728809:web:7abc7817f2a5554f5e1878',
    messagingSenderId: '230440728809',
    projectId: 'chatapptute-7964b',
    authDomain: 'chatapptute-7964b.firebaseapp.com',
    storageBucket: 'chatapptute-7964b.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDlvtFyUAuzLodXL5nmWTUea7kq-a7jLF0',
    appId: '1:230440728809:android:98919e74a93e8d6a5e1878',
    messagingSenderId: '230440728809',
    projectId: 'chatapptute-7964b',
    storageBucket: 'chatapptute-7964b.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCpqL0EIyof6XmQhm2aiI_3IgmgD2xyTX8',
    appId: '1:230440728809:ios:a1cf9d183ab8593c5e1878',
    messagingSenderId: '230440728809',
    projectId: 'chatapptute-7964b',
    storageBucket: 'chatapptute-7964b.firebasestorage.app',
    iosBundleId: 'com.example.chatapptute',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCpqL0EIyof6XmQhm2aiI_3IgmgD2xyTX8',
    appId: '1:230440728809:ios:a1cf9d183ab8593c5e1878',
    messagingSenderId: '230440728809',
    projectId: 'chatapptute-7964b',
    storageBucket: 'chatapptute-7964b.firebasestorage.app',
    iosBundleId: 'com.example.chatapptute',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBqqZUFk4UE2c25GCulSNBW2BnJWbKysX0',
    appId: '1:230440728809:web:782df5a5a1a6df745e1878',
    messagingSenderId: '230440728809',
    projectId: 'chatapptute-7964b',
    authDomain: 'chatapptute-7964b.firebaseapp.com',
    storageBucket: 'chatapptute-7964b.firebasestorage.app',
  );
}
