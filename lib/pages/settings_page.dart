// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:ew_2026_flutter_demo/widgets/settings_widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF222630),
      body: SettingsWidget(),
    );
  }
}
