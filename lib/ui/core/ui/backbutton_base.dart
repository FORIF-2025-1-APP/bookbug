import 'package:flutter/material.dart';

class BackButtonBase extends StatelessWidget {
  const BackButtonBase({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back_ios_new,
        color: Colors.black,
        size: 20,
      ),
      onPressed: () {
        Navigator.of(context).maybePop();
      },
      tooltip: '뒤로가기',
    );
  }
}
