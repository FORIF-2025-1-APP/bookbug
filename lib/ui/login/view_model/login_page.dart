import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

import 'package:bookbug/data/services/token_manager.dart';
import 'package:bookbug/data/services/auth_provider.dart';

import 'package:bookbug/ui/core/ui/input_base.dart';
import 'package:bookbug/ui/core/ui/button_base.dart';
import 'package:bookbug/ui/core/ui/checkbox_base.dart';
import 'package:bookbug/ui/login/view_model/register_page.dart';
import 'package:bookbug/ui/home/view_model/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool autoLogin = false;
  final storage = const FlutterSecureStorage();

  // 일반 로그인
  Future<void> login() async {
    final email = emailController.text;
    final password = passwordController.text;

    final url = Uri.parse(
      'https://forifbookbugapi.seongjinemong.app/api/auth/login',
    );
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (!mounted) return;

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final token = responseData['token'];
      final user = responseData['user'];

      await context.read<AuthProvider>().setToken(token);

      if (autoLogin) {
        await TokenManager.saveToken(token);
        await TokenManager.setAutoLogin(true);
      } else {
        await TokenManager.setAutoLogin(false);
        await TokenManager.clearToken();
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage(token: token)),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${user['username']} 님, 오늘도 책 읽을 준비 되셨나요?')),
      );
    } else if (response.statusCode == 401) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('이메일 또는 비밀번호가 올바르지 않습니다.')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('로그인 실패: ${response.statusCode}')));
    }
  }

  // 구글 로그인
  Future<void> loginWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('구글 로그인에 실패했습니다.');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.accessToken;

      print('Google User: ${googleUser.displayName}');
      print('Google ID Token: $idToken');

      final apiUrl = Uri.parse(
        'https://forifbookbugapi.seongjinemong.app/api/auth/google',
      );
      final apiResponse = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken}),
      );

      print('Google Login Response Status Code: ${apiResponse.statusCode}');
      print('Google Login Response Body: ${apiResponse.body}');

      if (!mounted) return;

      if (apiResponse.statusCode == 200) {
        final responseData = jsonDecode(apiResponse.body);
        final token = responseData['token'];
        final user = responseData['user'];

        // AuthProvider에 토큰 저장
        await context.read<AuthProvider>().setToken(token);

        if (autoLogin) {
          await TokenManager.saveToken(token);
          await TokenManager.setAutoLogin(true);
        } else {
          await TokenManager.setAutoLogin(false);
          await TokenManager.clearToken();
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage(token: token)),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${user['username']} 님, 오늘도 책 읽을 준비 되셨나요?')),
        );
      } else if (apiResponse.statusCode == 401) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('구글 로그인 실패: 잘못된 토큰')));
      } else if (apiResponse.statusCode == 500) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('구글 로그인 실패: 서버 오류')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('구글 로그인 실패: ${apiResponse.statusCode}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      print('Google Sign-In Exception: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('구글 로그인 중 에러 발생: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;
    const textColor = Colors.black;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                isDarkMode ? 'assets/logo_dark.png' : 'assets/logo_light.png',
                height: 70,
              ),
              const SizedBox(height: 60),
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
              const SizedBox(height: 24),
              ButtonBase(text: '로그인', onPressed: login),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: loginWithGoogle,
                  icon: Image.asset(
                    'assets/google_logo.png',
                    width: 20,
                    height: 20,
                  ),
                  label: const Text('Login with Google'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: textColor,
                    side: const BorderSide(color: Colors.black12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    textStyle: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CheckboxBase(
                    value: autoLogin,
                    label: '자동 로그인',
                    onChanged: (val) {
                      setState(() {
                        autoLogin = val ?? false;
                      });
                    },
                  ),
                  const SizedBox(width: 12),
                  const Text('|'),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterPage()),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: const Size(40, 30),
                    ),
                    child: Text(
                      '회원가입',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
