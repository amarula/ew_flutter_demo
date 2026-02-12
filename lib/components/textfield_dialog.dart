// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutekeyboard/flutekeyboard.dart';
import 'package:flutekeyboard/flutekeyboard_theme.dart';
import 'package:flutter_svg/svg.dart';

class TextFieldDialog extends StatefulWidget {
  const TextFieldDialog({
    required this.title,
    required this.oldValue,
    required this.onReturn,
    super.key,
    this.numeric = false,
    this.password = false,
    this.maxLength = false,
  });

  final String title;
  final String oldValue;
  final bool numeric;
  final bool password;
  final bool maxLength;
  final Function(String value) onReturn;

  @override
  State<TextFieldDialog> createState() => _TextFieldDialogState();

  static Future<void> displayAlphanumDialog(
    BuildContext context,
    String title,
    String oldValue,
    Function(String value) onReturn, {
    bool isPassword = false,
    bool maxLength = false,
  }) async {
    return showDialog(
      context: context,
      builder: (context) {
        return TextFieldDialog(
          title: title,
          oldValue: oldValue,
          password: isPassword,
          maxLength: maxLength,
          onReturn: (value) => onReturn(value),
        );
      },
    );
  }

  static Future<void> displayNumericDialog(
    BuildContext context,
    String title,
    String oldValue,
    Function(String value) onReturn, {
    bool isPassword = false,
  }) async {
    return showDialog(
      context: context,
      builder: (context) {
        return TextFieldDialog(
          title: title,
          oldValue: oldValue,
          numeric: true,
          password: isPassword,
          onReturn: (value) => onReturn(value),
        );
      },
    );
  }
}

class _TextFieldDialogState extends State<TextFieldDialog> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _obscureText = true;

  @override
  void initState() {
    _textController.text = widget.oldValue;

    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FluteKeyboardTheme()
      ..backgroundColor = const Color(0xff0d0e12).withAlpha(200)
      ..btnBackgroundColor = const Color(0xFF373e4e)
      ..btnSpecialBackgroundColor = const Color(0xff222630)
      ..btnReturnColor = Colors.lightBlue
      ..btnTextStyle = const TextStyle(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.w400,
      );

    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const Spacer(),
            GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              onTap: () {},
              child: AlertDialog(
                title: Row(
                  children: [
                    Text(widget.title),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        minimumSize: const Size(48, 48),
                        maximumSize: const Size(48, 48),
                      ),
                      child: FittedBox(
                        fit: BoxFit.none,
                        child: SvgPicture.asset(
                          width: 40,
                          height: 40,
                          'assets/svg/keyboard-close.svg',
                        ),
                      ),
                    ),
                  ],
                ),
                titleTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                ),
                backgroundColor: const Color(0xFF373e4e),
                content: SizedBox(
                  width: 600,
                  child: Center(
                    child: TextField(
                      obscureText: widget.password && _obscureText,
                      contextMenuBuilder: null,
                      maxLength: widget.maxLength ? 30 : null,
                      autofocus: true,
                      focusNode: _focusNode,
                      onTapOutside: (event) {
                        _focusNode.requestFocus();
                      },
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: widget.oldValue,
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff778199)),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff778199)),
                        ),
                        suffixIcon: Visibility(
                          visible: widget.password,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              minimumSize: const Size(40, 40),
                              maximumSize: const Size(40, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: FittedBox(
                              fit: BoxFit.none,
                              child: SvgPicture.asset(
                                width: 28,
                                height: 28,
                                _obscureText
                                    ? 'assets/svg/keyboard-hide-text-disabled.svg'
                                    : 'assets/svg/keyboard-hide-text-enabled.svg',
                              ),
                            ),
                          ),
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {},
              child: FluteKeyboard(
                width: 1024,
                height: 256 + 8,
                type: widget.numeric
                    ? FluteKeyboardType.numeric
                    : FluteKeyboardType.alphanumeric,
                textController: _textController,
                theme: theme,
                backspaceIcon: 'assets/png/keyboard-backspace.png',
                shiftIcon: 'assets/png/keyboard-caps-disabled.png',
                shiftActiveIcon: 'assets/png/keyboard-caps-enabled.png',
                returnIcon: 'assets/png/keyboard-enter.png',
                hideSpaceText: true,
                onReturn: () {
                  Navigator.pop(context);
                  widget.onReturn(_textController.text);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
