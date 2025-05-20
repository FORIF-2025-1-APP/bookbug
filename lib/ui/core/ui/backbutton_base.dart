import 'package:flutter/material.dart';

class BackButtonBase extends StatelessWidget {
  final VoidCallback? onPressed;
  const BackButtonBase({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
      onPressed: onPressed ?? () => Navigator.of(context).maybePop(),
      tooltip: '뒤로가기',
    );
  }
}
