import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      return userCredential;
    } catch (error) {
      print('Google sign-in error: $error');
      return null;
    }
  }

  Future<UserCredential?> createAccountWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: '', // Provide the email address for the user
        password: '', // Provide a password for the user
      );
      return userCredential;
    } catch (error) {
      print('Google account creation error: $error');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authentication'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                final UserCredential? userCredential = await signInWithGoogle();
                if (userCredential != null) {
                  // User signed in successfully
                  Navigator.pushNamed(context, '/profile');
                } else {
                  // Failed to sign in
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Sign-in Failed'),
                      content: Text('Failed to sign in with Google.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              icon: Icon(Icons.login),
              label: Text('Sign In with Google'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                final UserCredential? userCredential =
                    await createAccountWithGoogle();
                if (userCredential != null) {
                  // User account created and signed in successfully
                  Navigator.pushNamed(context, '/profile');
                } else {
                  // Failed to create account
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Account Creation Failed'),
                      content: Text('Failed to create account with Google.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              icon: Icon(Icons.person_add),
              label: Text('Create Account with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
