// Flutter imports:
import 'package:flutter/material.dart';

class SensorValueCard extends StatelessWidget {
  const SensorValueCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.unit,
    super.key,
  });

  final String title;
  final String value;
  final Widget icon;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF373e4e),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 16),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' $unit',
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
