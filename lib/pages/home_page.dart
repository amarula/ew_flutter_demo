// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:lottie/lottie.dart';

// Project imports:
import 'package:ew_2026_flutter_demo/components/home_page_appbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isHeating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomePageAppbar(),
      backgroundColor: const Color(0xFF222630),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Lottie.asset(
              'assets/lottie/${isHeating ? 'heating' : 'cooling'}_ring.json',
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('24°', style: TextStyle(fontSize: 72)),
                Text(isHeating ? 'Heat' : 'Cool'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
