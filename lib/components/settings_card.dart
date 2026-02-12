// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/flutter_svg.dart';

class SettingsCard extends StatelessWidget {
  const SettingsCard({
    required this.title,
    required this.value,
    required this.onPressed,
    required this.onLongPressed,
    this.iconAssetsPath,
    this.iconData,
    super.key,
  });

  final String title;
  final String value;
  final VoidCallback onPressed;
  final VoidCallback onLongPressed;
  final String? iconAssetsPath;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 560,
      height: 184,
      decoration: BoxDecoration(
        color: const Color(0xFF373e4e),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onPressed,
          onLongPress: onLongPressed,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (iconAssetsPath != null)
                      SvgPicture.asset(
                        iconAssetsPath!,
                        width: 20,
                        height: 20,
                      )
                    else if (iconData != null)
                      Icon(
                        iconData,
                        color: Colors.white,
                        size: 20,
                      ),

                    const SizedBox(width: 8),

                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                Text(
                  value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
