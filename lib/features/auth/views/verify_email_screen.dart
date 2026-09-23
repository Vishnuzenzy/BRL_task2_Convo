import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/auth_viewmodel.dart';
import '../../../core/theme/app_theme.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthViewModel>().logout(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.mark_email_unread_rounded,
              size: 80,
              color: Color(0xFF1E3A8A), // Royal Blue color
            ),
            const SizedBox(height: 24),
            const Text(
              'A verification email has been sent to your email address. Please check your inbox.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: authVm.isLoading
                    ? null
                    : () => context.read<AuthViewModel>().checkEmailVerified(),
                child: authVm.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('I have verified, Continue'),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () =>
                  context.read<AuthViewModel>().resendVerificationEmail(),
              child: const Text('Resend Email'),
            ),
          ],
        ),
      ),
    );
  }
}
