
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rewardly/providers/auth_provider.dart';
import 'package:rewardly/screens/auth/login_screen.dart';
import 'package:rewardly/screens/home_screen.dart';
import 'package:rewardly/screens/splash_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    switch (authProvider.status) {
      case AuthStatus.uninitialized:
        return const SplashScreen();
      case AuthStatus.authenticated:
        return const HomeScreen();
      case AuthStatus.unauthenticated:
        return const LoginScreen();
    }
  }
}
