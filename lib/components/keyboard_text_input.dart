// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutekeyboard/flutekeyboard.dart';
import 'package:flutekeyboard/flutekeyboard_theme.dart';

// Project imports:

class KeyboardTextInput extends StatefulWidget {
  const KeyboardTextInput({required this.onReturn, super.key});

  final ValueChanged<String> onReturn;

  @override
  State<KeyboardTextInput> createState() => _KeyboardTextInputState();
}

class _KeyboardTextInputState extends State<KeyboardTextInput> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FluteKeyboardTheme()
      ..backgroundColor = const Color.fromARGB(255, 209, 211, 215)
      ..btnBackgroundColor = const Color.fromARGB(255, 255, 255, 255)
      ..btnSpecialBackgroundColor = const Color.fromARGB(255, 171, 175, 183)
      ..btnReturnColor = Colors.blue.shade100
      ..btnTextStyle = const TextStyle(
        color: Colors.black,
        fontSize: 28,
      );

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Center(
            child: TextField(
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
              controller: _textController,
              focusNode: _focusNode,
              autofocus: true,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: FluteKeyboard(
              width: 800,
              type: FluteKeyboardType.alphanumeric,
              textController: _textController,
              theme: theme,
              backspaceIcon: 'assets/png/backspace.png',
              shiftIcon: 'assets/png/shift.png',
              shiftActiveIcon: 'assets/png/shift_active.png',
              onReturn: () => {
                setState(() {
                  widget.onReturn.call(_textController.text);
                }),
              },
            ),
          ),
        ],
      ),
    );
  }
}
