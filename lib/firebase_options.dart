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
    apiKey: 'AIzaSyCOdCFNt-HhLghQr1-TdaYK1nwOfRvlzfE',
    appId: '1:479058711483:web:4366edb2c9a4764b51aa9e',
    messagingSenderId: '479058711483',
    projectId: 'econo-app-397c6',
    authDomain: 'econo-app-397c6.firebaseapp.com',
    storageBucket: 'econo-app-397c6.appspot.com',
    measurementId: 'G-41RF1GV7D0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCYAjGGrwL6YgKfFWQ-RuSPEeQwS9dY58Q',
    appId: '1:479058711483:android:e5b016f34cbd16b751aa9e',
    messagingSenderId: '479058711483',
    projectId: 'econo-app-397c6',
    storageBucket: 'econo-app-397c6.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC2PGyBx4O7g0GAvLRKaFH-a8mqWDUQKIE',
    appId: '1:479058711483:ios:a9b1e366a2d2246351aa9e',
    messagingSenderId: '479058711483',
    projectId: 'econo-app-397c6',
    storageBucket: 'econo-app-397c6.appspot.com',
    iosClientId:
        '479058711483-lenbrldcv6p72kktg819b8741vlutpjo.apps.googleusercontent.com',
    iosBundleId: 'com.example.econoApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC2PGyBx4O7g0GAvLRKaFH-a8mqWDUQKIE',
    appId: '1:479058711483:ios:a9b1e366a2d2246351aa9e',
    messagingSenderId: '479058711483',
    projectId: 'econo-app-397c6',
    storageBucket: 'econo-app-397c6.appspot.com',
    iosClientId:
        '479058711483-lenbrldcv6p72kktg819b8741vlutpjo.apps.googleusercontent.com',
    iosBundleId: 'com.example.econoApp',
  );
}
