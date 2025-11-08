import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  static const _burntOrange = Color(0xFFC95C27);
  static const _titleBrown = Color(0xFF5B3F30);

  late final AnimationController _ac;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fade = CurvedAnimation(parent: _ac, curve: Curves.easeInOut);
    _ac.forward();

    Timer(const Duration(seconds: 4), () {
      final user = FirebaseAuth.instance.currentUser;
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, user != null ? '/home' : '/auth');
    });
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/study_mate_bg_clean.png',
            fit: BoxFit.cover,
          ),
          Container(color: Colors.white.withOpacity(0.10)),
          FadeTransition(
            opacity: _fade,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 84,
                    height: 84,
                    decoration: const BoxDecoration(
                      color: _burntOrange,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.menu_book_rounded,
                        size: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Study Mate',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: _titleBrown,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Focus. Learn. Grow.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.brown.shade600,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  CircularProgressIndicator(
  valueColor: AlwaysStoppedAnimation<Color>(_burntOrange),
  strokeWidth: 2.5,
),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}