import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/local_session_service.dart';

import '../data/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final LocalSessionService _localSessionService = LocalSessionService();

  bool _isLoading = false;
  String? _errorMessage;
  User? _currentUser;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isEmailVerified => _currentUser?.emailVerified ?? false;

  AuthViewModel() {
    _initAuthState();
  }

  // Session persistence listener
  void _initAuthState() {
    _authService.authStateChanges.listen((User? user) async {
      _currentUser = user;
      final prefs = await SharedPreferences.getInstance();
      if (user != null) {
        await prefs.setBool('is_logged_in', true);
      } else {
        await prefs.setBool('is_logged_in', false);
      }
      notifyListeners();
    });
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Email Login
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    clearError();

    try {
      final credential = await _authService.signInWithEmail(
        email: email.trim(),
        password: password.trim(),
      );
      await _localSessionService.saveSessionData(loginMethod: 'email_password');

      _currentUser = credential.user; // User state update hona zaroori hai
      _setLoading(false);
      notifyListeners(); // <-- YE LINE SABSE IMPORTANT HAI
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  // Email Signup
  Future<bool> signup(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authService.signUpWithEmail(email: email, password: password);
      await _localSessionService.saveSessionData(loginMethod: 'google');

      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  // Google Sign In
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final cred = await _authService.signInWithGoogle();
      _setLoading(false);
      return cred != null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  // Sign Out
  Future<void> logout() async {
    _setLoading(true);
    await _authService.signOut();
    await _authService.signOut();
    await _localSessionService.clearSessionData(); // Requirement fulfilled
    _currentUser = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('is_logged_in');
    _setLoading(false);
  }

  // Refresh User State to check verification status
  Future<void> checkEmailVerified() async {
    _setLoading(true);
    try {
      await _authService.reloadUser();
      // Reload hone ke baad naya user instance ViewModel me update karo
      _currentUser = _authService.currentUser;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Resend verification email manually
  Future<void> resendVerificationEmail() async {
    try {
      await _authService.sendEmailVerification();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}

