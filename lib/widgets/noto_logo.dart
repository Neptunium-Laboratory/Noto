import 'package:flutter/material.dart';

/// The Noto app icon: a rounded light square containing a blue circle
/// with three light-blue stars. Sourced from `assets/images/noto_logo.png`
/// — do not redesign it in code; this widget only controls size/shape
/// framing around the supplied asset.
class NotoLogo extends StatelessWidget {
  const NotoLogo({super.key, this.size = 96});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.28),
      child: Image.asset(
        'assets/images/noto_logo.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
