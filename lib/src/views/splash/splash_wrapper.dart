import 'package:flutter/material.dart';
import 'animated_splash.dart';
import 'intro_slider.dart';

class SplashWrapper extends StatefulWidget {
  const SplashWrapper({super.key});

  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  bool _showIntro = false;

  void _goToIntro() {
    setState(() => _showIntro = true);
  }

  void _goToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    if (_showIntro) {
      return IntroSlider(onComplete: _goToLogin);
    }
    return AnimatedSplash(onComplete: _goToIntro);
  }
}
