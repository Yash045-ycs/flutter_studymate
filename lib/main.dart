import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'data/firebase_options.dart';
import 'common/theme.dart';
import 'modules/splash/views/splash_screen.dart';
import 'modules/auth/views/auth_screen.dart';
import 'modules/dashboard/views/home_screen.dart';
import 'modules/auth/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
  BlocProvider(
    create: (context) => AuthBloc(),
    child: const MyApp(),
  ),
);

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Mate',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: const RootPage(),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/auth': (_) => const AuthScreen(),
        '/home': (_) => const HomeScreen(),
      },
    );
  }
}

/// This widget decides whether to show splash, auth, or home based on real auth state.
class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Optional: Show splash while checking login
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }
        if (snapshot.hasData) {
          return const HomeScreen();
        }
        return const AuthScreen();
      },
    );
  }
}
