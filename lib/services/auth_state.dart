// lib/services/auth_state.dart

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum AuthStatus { initial, authenticated, guest, unauthenticated, error }

class AuthStateProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthStatus _status = AuthStatus.initial;
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _userData;

  // Getters
  AuthStatus get status => _status;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isGuest => _status == AuthStatus.guest;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get userData => _userData;

  AuthStateProvider() {
    _initializeAuthState();
  }

  void _initializeAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    final isGuest = prefs.getBool('is_guest') ?? false;

    _auth.authStateChanges().listen((User? user) async {
      if (user != null) {
        await _loadUserData();
        _status = AuthStatus.authenticated;
      } else if (isGuest) {
        _status = AuthStatus.guest;
      } else {
        _userData = null;
        _status = AuthStatus.unauthenticated;
      }
      notifyListeners();
    });
  }

  Future<bool> resetPassword(String email) async {
    try {
      _isLoading = true;
      _setError(null);
      notifyListeners();

      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth errors
      switch (e.code) {
        case 'user-not-found':
          _setError('No user found with this email.');
          break;
        case 'invalid-email':
          _setError('The email address is invalid.');
          break;
        default:
          _setError(e.message ?? 'Failed to send reset email.');
      }
      return false;
    } catch (e) {
      _setError('An unexpected error occurred.');
      print('Reset password error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadUserData() async {
    if (_auth.currentUser != null) {
      try {
        final docSnapshot = await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .get();

        if (docSnapshot.exists) {
          _userData = docSnapshot.data();
          // Cache user data
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(
              'cached_user_data', docSnapshot.data().toString());
          notifyListeners();
        }
      } catch (e) {
        print('Error loading user data: $e');
        _setError(e.toString());
      }
    }
  }

  Future<Map<String, dynamic>?> getUserData() async {
    if (_status == AuthStatus.authenticated && _auth.currentUser != null) {
      try {
        final docSnapshot = await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .get();

        _userData = docSnapshot.data();
        return _userData;
      } catch (e) {
        _setError(e.toString());
        return null;
      }
    }
    return null;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    if (error != null) {
      _status = AuthStatus.error;
    }
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  Future<bool> loginWithEmailAndPassword(String email, String password) async {
    try {
      _setLoading(true);
      _clearError();

      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'user_token', await userCredential.user!.getIdToken() ?? '');
        await prefs.setString('email', email);
        await prefs.setBool('is_guest', false);

        _status = AuthStatus.authenticated;
        await _loadUserData();
        return true;
      }
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register(String email, String password, String name) async {
    try {
      _setLoading(true);
      _clearError();

      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Create user document in Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': email,
          'name': name,
          'createdAt': FieldValue.serverTimestamp(),
          'status': 'Active',
          'nationality': 'Not Set',
          'balance': 0.0,
          'bank_name': 'Not Set',
          'card_number': '',
        });

        _status = AuthStatus.authenticated;
        await _loadUserData();
        return true;
      }
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      _setLoading(true);
      _clearError();

      await _auth.signOut();

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      _userData = null;
      _status = AuthStatus.unauthenticated;
    } catch (e) {
      _setError('Logout failed: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> setGuestMode(bool isGuest) async {
    try {
      _setLoading(true);
      _clearError();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_guest', isGuest);

      if (isGuest) {
        _status = AuthStatus.guest;
      } else {
        _status = AuthStatus.unauthenticated;
        _userData = null;
        await prefs.clear();
      }
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    try {
      _setLoading(true);
      _clearError();

      if (_auth.currentUser == null) {
        _setError('Not authenticated');
        return false;
      }

      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update(data);

      await _loadUserData();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateCardDetails(Map<String, dynamic> cardData) async {
    try {
      _setLoading(true);
      _clearError();

      if (_auth.currentUser == null) {
        _setError('Not authenticated');
        return false;
      }

      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'card_number': cardData['card_number'],
        'bank_name': cardData['bank_name'],
        'balance': cardData['balance'],
      });

      await _loadUserData();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
