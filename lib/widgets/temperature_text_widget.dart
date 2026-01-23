// Flutter imports:
import 'package:flutter/material.dart';

class TemperatureTextWidget extends StatelessWidget {
  const TemperatureTextWidget({
    required this.degree,
    required this.fontSize,
    required this.decimal,
    super.key,
  });

  final String degree;
  final String decimal;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: degree,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
            ),
          ),
          WidgetSpan(
            child: Transform.translate(
              offset: Offset(4, -(fontSize * 44 / 100)),
              child: Text(
                '°C',
                style: TextStyle(
                  fontSize: fontSize - (fontSize * 70 / 100),
                ),
              ),
            ),
          ),
          WidgetSpan(
            child: Transform.translate(
              offset: Offset(-(fontSize * 21 / 100), 4),
              child: Text(
                ',$decimal',
                style: TextStyle(fontSize: fontSize - (fontSize * 70 / 100)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
