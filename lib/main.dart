import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bookbug/data/services/auth_provider.dart';
import 'package:bookbug/ui/login/view_model/login_page.dart';
import 'package:bookbug/ui/core/themes/theme.dart';
import 'package:bookbug/ui/homepage/view_model/home_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: const MyApp(),
    ),
  );
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
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return auth.token == null
              ? const LoginPage()
              : HomePage(token: auth.token!); // const 제거
        },
      ),
    );
  }
}
