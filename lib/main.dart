import 'package:flutter/material.dart';
import 'package:bookbug/ui/login/view_model/login_page.dart';
import 'package:bookbug/ui/core/themes/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '책 리뷰 앱',
      theme: ThemeData(
        colorScheme:
            MediaQuery.platformBrightnessOf(context) == Brightness.dark
                ? MaterialTheme.darkScheme().toColorScheme()
                : MaterialTheme.lightScheme().toColorScheme(),
        fontFamily: 'Pretendard', // 한글 폰트
      ),
      home: const LoginPage(),
    );
  }
}