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
    apiKey: 'AIzaSyDtGdysJq6YG2CX9yvSOxBy1KS8rM_vTKQ',
    appId: '1:997576782837:web:34ca06fcba2af61fbe26bc',
    messagingSenderId: '997576782837',
    projectId: 'touristop-dev-c1abf',
    authDomain: 'touristop-dev-c1abf.firebaseapp.com',
    storageBucket: 'touristop-dev-c1abf.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD4pwxS6sRVZGg79ceNaHoQWfsoGB6Sevs',
    appId: '1:997576782837:android:a2fde03a9e634962be26bc',
    messagingSenderId: '997576782837',
    projectId: 'touristop-dev-c1abf',
    storageBucket: 'touristop-dev-c1abf.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAzpMEXAAMBUb7RMBP2811ARkdJ4tmY0n0',
    appId: '1:997576782837:ios:aafd5f9101b5a48bbe26bc',
    messagingSenderId: '997576782837',
    projectId: 'touristop-dev-c1abf',
    storageBucket: 'touristop-dev-c1abf.appspot.com',
    androidClientId: '997576782837-6oemb8n9d8lntq41fkeqa8dlisnadv59.apps.googleusercontent.com',
    iosClientId: '997576782837-kmc8nuclvraieru9ace9dmnd8pfhe1c3.apps.googleusercontent.com',
    iosBundleId: 'com.example.touristop',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAzpMEXAAMBUb7RMBP2811ARkdJ4tmY0n0',
    appId: '1:997576782837:ios:aafd5f9101b5a48bbe26bc',
    messagingSenderId: '997576782837',
    projectId: 'touristop-dev-c1abf',
    storageBucket: 'touristop-dev-c1abf.appspot.com',
    androidClientId: '997576782837-6oemb8n9d8lntq41fkeqa8dlisnadv59.apps.googleusercontent.com',
    iosClientId: '997576782837-kmc8nuclvraieru9ace9dmnd8pfhe1c3.apps.googleusercontent.com',
    iosBundleId: 'com.example.touristop',
  );
}
