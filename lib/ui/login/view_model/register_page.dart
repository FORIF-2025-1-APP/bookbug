import 'package:flutter/material.dart';
import 'package:bookbug/ui/core/ui/input_base.dart';
import 'package:bookbug/ui/core/ui/button_base.dart';
import 'package:bookbug/ui/core/ui/checkbox_base.dart';
import 'package:bookbug/ui/core/ui/backbutton_base.dart';
import 'package:bookbug/ui/login/view_model/login_page.dart';
import 'package:bookbug/ui/login/view_model/register_policy_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final usernameController = TextEditingController();

  bool terms1 = false;
  bool terms2 = false;

  void _navigateToPolicy(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterPolicyPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const textColor = Colors.black;

    return Scaffold(
      appBar: AppBar(
        leading: BackButtonBase(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
          },
        ),
        title: const Text('회원가입'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InputBase(
                label: 'email',
                hintText: '이메일을 입력하세요',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              InputBase(
                label: 'password',
                hintText: '비밀번호를 입력하세요',
                obscureText: true,
                controller: passwordController,
              ),
              const SizedBox(height: 16),
              InputBase(
                label: 'password confirm',
                hintText: '비밀번호를 다시 입력하세요',
                obscureText: true,
                controller: confirmPasswordController,
              ),
              const SizedBox(height: 16),
              InputBase(
                label: 'username',
                hintText: '닉네임을 입력하세요',
                controller: usernameController,
              ),
              const SizedBox(height: 24),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CheckboxBase(
                      value: terms1,
                      label: '이용약관에 동의합니다',
                      onChanged: (val) {
                        setState(() {
                          terms1 = val ?? false;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 18),
                    onPressed: () => _navigateToPolicy(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CheckboxBase(
                      value: terms2,
                      label: '개인정보 수집 및 이용에 동의합니다',
                      onChanged: (val) {
                        setState(() {
                          terms2 = val ?? false;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 18),
                    onPressed: () => _navigateToPolicy(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              ButtonBase(
                text: '회원가입',
                onPressed: () {
                  print('email: ${emailController.text}');
                  print('password: ${passwordController.text}');
                  print('username: ${usernameController.text}');
                  print('terms1: $terms1 / terms2: $terms2');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
