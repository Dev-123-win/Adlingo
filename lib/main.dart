
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rewardly/providers/auth_provider.dart';
import 'package:rewardly/services/auth_service.dart';
import 'package:rewardly/screens/auth/login_screen.dart';
import 'package:rewardly/screens/auth/register_screen.dart';
import 'package:rewardly/screens/home_screen.dart';
import 'package:rewardly/screens/splash_screen.dart';
import 'package:rewardly/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Create provider instances before runApp
  final authService = AuthService();
  final authProvider = AuthProvider(authService);

  runApp(MyApp(authService: authService, authProvider: authProvider));
}

class MyApp extends StatelessWidget {
  final AuthService authService;
  final AuthProvider authProvider;

  const MyApp({super.key, required this.authService, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>.value(value: authService),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
      ],
      child: const AppRouter(),
    );
  }
}

class AppRouter extends StatefulWidget {
  const AppRouter({super.key});

  @override
  State<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<AppRouter> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();

    _router = GoRouter(
      refreshListenable: authProvider,
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
      ],
      redirect: (context, state) {
        final auth = context.read<AuthProvider>();
        final isAuthenticated = auth.isAuthenticated;
        final isAuthenticating = auth.status == AuthStatus.uninitialized;

        if (isAuthenticating) {
          return '/';
        }

        final location = state.matchedLocation;
        final isAuthRoute = location == '/login' || location == '/register';

        if (!isAuthenticated && !isAuthRoute) {
          return '/login';
        }

        if (isAuthenticated && (isAuthRoute || location == '/')) {
          return '/home';
        }

        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp.router(
      routerConfig: _router,
      title: 'Rewardly',
      theme: themeProvider.lightTheme,
      darkTheme: themeProvider.darkTheme,
      themeMode: themeProvider.themeMode,
      debugShowCheckedModeBanner: false,
    );
  }
}
