import 'package:flutter/material.dart';

class BackButtonBase extends StatelessWidget {
  final VoidCallback? onPressed;
  const BackButtonBase({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDarkMode ? Colors.white : Colors.black;

    return IconButton(
      icon: Icon(Icons.arrow_back_ios_new, color: iconColor),
      onPressed: onPressed ?? () => Navigator.of(context).maybePop(),
      tooltip: '뒤로가기',
    );
  }
}
