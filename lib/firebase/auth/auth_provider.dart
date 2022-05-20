import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseAuth get auth => _auth;
  User? _user;
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

    final userCredential = await _auth.signInWithCredential(credential);
    _user = userCredential.user;

    if (_user != null) {
      final QuerySnapshot resultQuery = await FirebaseFirestore.instance
          .collection('users')
          .where(
            'id',
            isEqualTo: _user!.uid,
          )
          .get();
      final List<DocumentSnapshot> documentSnapshots = resultQuery.docs;

      if (documentSnapshots.isEmpty) {
        FirebaseFirestore.instance.collection('users').doc(_user!.uid).set({
          'user_ID': _user!.uid,
          'email': _user!.email,
          'photo': _user!.photoURL,
          'name': _user!.displayName,
        });
      }
    }
    notifyListeners();
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<Resource?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      switch (result.status) {
        case LoginStatus.success:
          final AuthCredential facebookCredential =
              FacebookAuthProvider.credential(result.accessToken!.token);
          final userCredential =
              await _auth.signInWithCredential(facebookCredential);
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
    } on FirebaseAuthException catch (_) {
      rethrow;
    }
  }
}

class Resource {
  final Status? status;
  Resource({required this.status});
}

enum Status { success, error, cancelled }
