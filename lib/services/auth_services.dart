// lib/services/auth_services.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> loginWithEmailOrUsername(
      String emailOrUsername, String password) async {
    String email = emailOrUsername;

    if (!emailOrUsername.contains('@')) {
      final usernameDoc =
          await _firestore.collection('usernames').doc(emailOrUsername).get();

      if (usernameDoc.exists) {
        email = usernameDoc.data()?['email'];
      } else {
        throw FirebaseAuthException(
            code: 'user-not-found',
            message: 'No user found with this username');
      }
    }

    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }
}
