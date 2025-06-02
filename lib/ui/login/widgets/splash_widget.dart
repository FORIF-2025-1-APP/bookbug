import 'dart:async';
import 'package:flutter/material.dart';

class SplashWidget extends StatefulWidget {
  final bool isLoggedIn;

  const SplashWidget({super.key, required this.isLoggedIn});

  @override
  State<SplashWidget> createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);

    Timer(const Duration(seconds: 2), () {
      _controller.forward().whenComplete(() {
        if (widget.isLoggedIn) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          Navigator.pushReplacementNamed(context, '/login');
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.platformBrightnessOf(context) == Brightness.dark;

    return Scaffold(
      body: FadeTransition(
        opacity: _opacityAnimation,
        child: Center(
          child: Image.asset(
            isDarkMode ? 'assets/logo_dark.png' : 'assets/logo_light.png',
            width: 70,
            height: 70,
          ),
        ),
      ),
    );
  }
}
