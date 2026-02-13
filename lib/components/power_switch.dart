// Flutter imports:
import 'package:flutter/material.dart';

class PowerSwitch extends StatefulWidget {
  const PowerSwitch({
    required this.turnedOn,
    required this.onChanged,
    this.height = 120,
    super.key,
  });

  final bool turnedOn;
  final ValueChanged<bool> onChanged;
  final double height;

  @override
  State<PowerSwitch> createState() => _PowerSwitchState();
}

class _PowerSwitchState extends State<PowerSwitch> {
  static const WidgetStateProperty<Icon> thumbIcon =
      WidgetStateProperty<Icon>.fromMap(<WidgetStatesConstraint, Icon>{
        WidgetState.selected: Icon(
          Icons.power_settings_new,
          color: Colors.white,
        ),
        WidgetState.any: Icon(Icons.power_settings_new),
      });

  static const trackOutlineColor = WidgetStateProperty<Color>.fromMap(
    <WidgetStatesConstraint, Color>{
      WidgetState.selected: Colors.white,
      WidgetState.any: Color(0xFF1A1D24),
    },
  );

  @override
  Widget build(BuildContext context) {
    final turnedOn = widget.turnedOn;

    return SizedBox(
      height: widget.height,
      child: FittedBox(
        fit: BoxFit.fill,
        child: Switch(
          activeThumbColor: const Color(0xFF222630),
          activeTrackColor: Colors.white,
          inactiveTrackColor: const Color(0xFF1A1D24),
          inactiveThumbColor: Colors.grey,
          trackOutlineColor: trackOutlineColor,
          thumbIcon: thumbIcon,
          value: turnedOn,
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
