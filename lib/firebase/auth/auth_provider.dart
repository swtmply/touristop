import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseAuth get auth => _auth;
  late User? _user;
  User? get user => _user;

  Future googleLogout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }

  Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();

    if (googleUser == null) return;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential =await _auth.signInWithCredential(credential);
    _user = userCredential.user;
    notifyListeners();
  }

  Future<Resource?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      switch (result.status) {
        case LoginStatus.success:
          final AuthCredential facebookCredential =
              FacebookAuthProvider.credential(result.accessToken!.token);
          final userCredential = await _auth.signInWithCredential(facebookCredential);
          _user = userCredential.user;
          notifyListeners();
          return Resource(status: Status.success);
        case LoginStatus.cancelled:
          return Resource(status: Status.cancelled);
        case LoginStatus.failed:
          return Resource(status: Status.error);
        default:
          return null;
      }
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }
}

class Resource {
  final Status? status;
  Resource({required this.status});
}

enum Status { success, error, cancelled }
