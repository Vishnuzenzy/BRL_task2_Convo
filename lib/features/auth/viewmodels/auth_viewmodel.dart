import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;
  User? _currentUser;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

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
    _errorMessage = null;
    try {
      await _authService.signInWithEmail(email: email, password: password);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  // Email Signup
  Future<bool> signup(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authService.signUpWithEmail(email: email, password: password);
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('is_logged_in');
    _setLoading(false);
  }
}