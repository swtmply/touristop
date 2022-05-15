import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:touristop/main.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  var loading = false;

  void _loginFacebook() async {
    setState(() {
      loading = true;
    });

    try {
      final FacebookLoginResult = await FacebookAuth.instance.login();
      final userData = await FacebookAuth.instance.getUserData();

      final FacebookAuthCredential = FacebookAuthProvider.credential(
          FacebookLoginResult.accessToken!.token);
      await FirebaseAuth.instance.signInWithCredential(FacebookAuthCredential);

      await FirebaseFirestore.instance.collection('tourist').add({
        'email': userData['email'],
        'name': userData['name'],
        'imageUrl': userData['image']['data']['url'],
      });

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => LoginScreen()), (route) => false);
    } on FirebaseException catch (e) {
      var title = '';
      switch (e.code) {
        case 'account-exist-with-different-credential':
          title = 'This account exist in a different sign in provider';
          break;
        case 'invalid-credential':
          title = 'unknown error occured';
          break;
        case 'operation-not-allowed':
          title = 'This operation is not allowed';
          break;
        case 'user-disabled':
          title = 'The user you logged in to has been disabled';
          break;
        case 'user-not-found':
          title = 'The user you logged in to cannot be found';
          break;
      }
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Login with Facebook Failed'),
                content: Text(title),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Ok'))
                ],
              ));
    } finally {}
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final data = ref.watch(userProvider);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlatButton(
            padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            color: const Color.fromRGBO(237, 237, 237, 1.0),
            onPressed: () async {
              _loginFacebook();
            },
            child: const Text(
              'Facebook Login',
              style: const TextStyle(
                color: Color.fromRGBO(31, 31, 31, 1.0),
                fontSize: 20,
              ),
            ),
          ),
          if (loading) ...[
            const SizedBox(height: 15),
            const Center(child: const CircularProgressIndicator()),
          ],
          const SizedBox(height: 20),
          FlatButton(
            padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            color: const Color.fromRGBO(237, 237, 237, 1.0),
            onPressed: () async {
              data.googleLogin();
            },
            child: const Text(
              'Google Login',
              style: TextStyle(
                color: Color.fromRGBO(31, 31, 31, 1.0),
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
