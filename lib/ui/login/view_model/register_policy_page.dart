import 'package:flutter/material.dart';

class RegisterPolicyPage extends StatelessWidget {
  const RegisterPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('약관 상세보기')),
      body: const Center(child: Text('약관 내용 보여주기')),
    );
  }
}
