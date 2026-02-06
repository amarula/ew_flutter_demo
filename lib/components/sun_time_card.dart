// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/flutter_svg.dart';

class SunTimeCard extends StatelessWidget {
  const SunTimeCard({
    required this.label,
    required this.time,
    required this.icon,
    super.key,
  });

  final String label;
  final String time;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 168,
      height: 96,
      decoration: BoxDecoration(
        color: const Color(0xFF373e4e),
        borderRadius: BorderRadius.circular(24),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              SvgPicture.asset(
                icon,
                width: 56,
                height: 56,
              ),

              const Spacer(),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
