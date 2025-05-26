import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:bookbug/ui/core/ui/input_base.dart';
import 'package:bookbug/ui/core/ui/button_base.dart';
import 'package:bookbug/ui/core/ui/checkbox_base.dart';
import 'package:bookbug/ui/core/ui/backbutton_base.dart';
import 'package:bookbug/ui/login/view_model/login_page.dart';
import 'package:bookbug/ui/login/widgets/register_policy_modal.dart';

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

  Future<void> register() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    final username = usernameController.text.trim();

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    // 1. 필수값 입력 검사
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty || username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 항목을 입력해주세요.')),
      );
      return;
    }

    // 2. 이메일 유효성 검사
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('올바른 이메일 형식이 아닙니다.')),
      );
      return;
    }

    // 3. 비밀번호 일치 검사
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('비밀번호가 일치하지 않습니다.')),
      );
      return;
    }

    // 4. 약관 동의 여부 검사
    if (!terms1 || !terms2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('약관에 모두 동의해야 합니다.')),
      );
      return;
    }

    final url = Uri.parse('https://forifbookbugapi.seongjinemong.app/api/auth/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'username': username,
      }),
    );

    if (!mounted) return;

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('회원가입 성공! 로그인 페이지로 이동합니다.')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } else if (response.statusCode == 409) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미 존재하는 이메일입니다.')),
      );
    } else if (response.statusCode == 400) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('입력값을 확인해주세요.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입 실패: ${response.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: CheckboxBase(
                      value: terms1,
                      label: '가입약관',
                      onChanged: (val) {
                        setState(() {
                          terms1 = val ?? false;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    alignment: Alignment.center,
                    icon: const Icon(Icons.arrow_forward_ios, size: 18),
                    // 이용약관 모달 열기
onPressed: () async {
  final result = await Navigator.push<bool>(
    context,
    MaterialPageRoute(
      builder: (_) => RegisterPolicyModal(
        title: '이용약관',
        content: termsOfUse,
        isChecked: terms1,
      ),
    ),
  );

  if (result != null && result != terms1) {
    setState(() {
      terms1 = result;
    });
  }
},


                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: CheckboxBase(
                      value: terms2,
                      label: '개인정보 수집 및 이용 동의',
                      onChanged: (val) {
                        setState(() {
                          terms2 = val ?? false;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    alignment: Alignment.center,
                    icon: const Icon(Icons.arrow_forward_ios, size: 18),
                    // 개인정보 수집 모달 열기
onPressed: () async {
  final result = await Navigator.push<bool>(
    context,
    MaterialPageRoute(
      builder: (_) => RegisterPolicyModal(
        title: '개인정보 수집 및 이용 동의',
        content: privacyPolicy,
        isChecked: terms2,
      ),
    ),
  );

  if (result != null && result != terms2) {
    setState(() {
      terms2 = result;
    });
  }
},


                  ),
                ],
              ),
              const SizedBox(height: 24),
              ButtonBase(
                text: '회원가입',
                onPressed: register,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
