// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/flutter_svg.dart';

class HomePageAppbar extends StatelessWidget implements PreferredSizeWidget {
  const HomePageAppbar({super.key});

  String _wifiStrenghtIcon() {
    return 'assets/svg/wifi_off.svg';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      color: Colors.transparent,
      child: Row(
        spacing: 12,
        children: [
          Padding(
            padding: const EdgeInsetsGeometry.only(left: 16),
            child: SvgPicture.asset(
              _wifiStrenghtIcon(),
              width: 40,
              height: 40,
            ),
          ),
          const Text(
            '08:56 • 18 NOV 2025',
            style: TextStyle(fontSize: 20),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsetsGeometry.only(right: 16),
            child: ElevatedButton(
              onPressed: () {},
              child: FittedBox(
                fit: BoxFit.none,
                child: SvgPicture.asset(
                  'assets/svg/settings.svg',
                  width: 48,
                  height: 48,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(54);
}
