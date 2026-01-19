// Flutter imports:
import 'package:flutter/material.dart';

class TempChangeButton extends StatelessWidget {
  const TempChangeButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final Icon icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        iconSize: 60,
        icon: icon,
        onPressed: onPressed,
      ),
    );
  }
}
