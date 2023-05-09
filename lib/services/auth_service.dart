import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Register with email and password
  Future registerWithEmailAndPassword(
      String email, String password, String name, String pictureUrl) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      await user.updatePhotoURL(pictureUrl);
      await user.updateDisplayName(name);
      await user.sendEmailVerification();
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // Sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // Sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future updateProfile(String name, String email, String photoURL) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        await user.updateEmail(email);
        await user.updateDisplayName(name);
        await user.updatePhotoURL(photoURL);
        return user;
      }
    } catch (e) {
      print('Error updating profile: $e');
    }
  }
}
