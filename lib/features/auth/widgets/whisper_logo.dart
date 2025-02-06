import 'package:flutter/material.dart';

class WhisperLogo extends StatelessWidget {
  final double size;

  const WhisperLogo({
    super.key,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      width: size,
      height: size,
    );
  }
} 