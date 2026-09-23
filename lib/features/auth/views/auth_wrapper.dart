import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'login_screen.dart';
import 'main_navigation_screen.dart';
import 'verify_email_screen.dart'; 

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();

    if (authVm.isAuthenticated) {
      // Check if email is verified. (Google Sign-In usually auto-verifies).
      if (authVm.isEmailVerified) {
        return const HomeScreen();
      } else {
        return const VerifyEmailScreen();
      }
    } else {
      return const LoginScreen();
    }
  }
}