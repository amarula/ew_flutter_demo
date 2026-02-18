// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

class TempChangeButton extends StatefulWidget {
  const TempChangeButton({
    required this.icon,
    required this.onPressed,
    required this.onLongPressed,
    super.key,
  });

  final Icon icon;
  final VoidCallback onPressed;
  final VoidCallback onLongPressed;

  @override
  State<TempChangeButton> createState() => _TempChangeButtonState();
}

class _TempChangeButtonState extends State<TempChangeButton> {
  Timer? _longPressTimer;

  @override
  void dispose() {
    _longPressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) {
        widget.onLongPressed();

        _longPressTimer = Timer.periodic(const Duration(milliseconds: 200), (
          timer,
        ) {
          widget.onLongPressed();
        });
      },
      onLongPressEnd: (details) {
        _longPressTimer?.cancel();
      },
      onLongPressCancel: () {
        _longPressTimer?.cancel();
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 2),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          iconSize: 60,
          icon: widget.icon,
          onPressed: widget.onPressed,
        ),
      ),
    );
  }
}
