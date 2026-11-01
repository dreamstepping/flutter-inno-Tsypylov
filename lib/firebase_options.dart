import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform => web;

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBWKpTADzl7kViDjSDqfd2NpC8eQz0S-q4',
    authDomain: 'music-catalogue-7528b.firebaseapp.com',
    projectId: 'music-catalogue-7528b',
    storageBucket: 'music-catalogue-7528b.firebasestorage.app',
    messagingSenderId: '501816078781',
    appId: '1:501816078781:web:fbfa6dd2f2480f725f62d4D',
  );
}
