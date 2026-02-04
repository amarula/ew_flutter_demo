// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/svg.dart';

// Project imports:
import 'package:ew_2026_flutter_demo/pages/home_page.dart' show HomePage;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class MenuEntry {
  MenuEntry({
    required this.widget,
    required this.iconPath,
  });

  final Widget widget;
  final String iconPath;
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<MenuEntry> _menuList = [
    MenuEntry(
      widget: const HomePage(),
      iconPath: 'assets/svg/home.svg',
    ),
    MenuEntry(
      widget: const Placeholder(),
      iconPath: 'assets/svg/weather.svg',
    ),
    MenuEntry(
      widget: const Placeholder(),
      iconPath: 'assets/svg/settings.svg',
    ),
  ];

  Widget menuButton(int index) {
    final entry = _menuList[index];

    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(72, 72),
        maximumSize: const Size(72, 72),
      ),
      child: FittedBox(
        fit: BoxFit.none,
        child: SvgPicture.asset(
          entry.iconPath,
          width: 48,
          height: 48,
        ),
      ),
    );
  }

  @override
  void initState() {
    _selectedIndex = 0;
    super.initState();
  }

  Widget wifiStatusIcon(int strength) {
    return SvgPicture.asset(
      'assets/svg/wifi_offline.svg',
      width: 48,
      height: 48,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D323E),
      body: Row(
        children: [
          SizedBox(
            width: 64,
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  color: const Color(0xFF1A1D24),
                  child: Center(
                    child: wifiStatusIcon(3),
                  ),
                ),

                const SizedBox(height: 12),

                Expanded(
                  child: ListView.separated(
                    itemCount: _menuList.length,
                    itemBuilder: (context, index) => menuButton(index),
                    separatorBuilder: (context, index) {
                      return const Divider(
                        height: 20,
                        color: Colors.transparent,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: _menuList[_selectedIndex].widget,
          ),
        ],
      ),
    );
  }
}
