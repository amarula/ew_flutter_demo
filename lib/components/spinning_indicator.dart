// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/flutter_svg.dart';

class SpinningIndicator extends StatefulWidget {
  const SpinningIndicator({super.key});

  @override
  State<SpinningIndicator> createState() => _SpinningIndicatorState();
}

class _SpinningIndicatorState extends State<SpinningIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    unawaited(_controller.repeat());

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: SvgPicture.asset(
        'assets/svg/sync.svg',
        width: 30,
        height: 30,
      ),
    );
  }
}
