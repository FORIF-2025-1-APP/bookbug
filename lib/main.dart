import 'package:bookbug/ui/core/themes/theme_mode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bookbug/data/services/token_manager.dart';
import 'package:bookbug/data/services/auth_provider.dart';
import 'package:bookbug/ui/login/view_model/login_page.dart';
import 'package:bookbug/ui/core/themes/theme.dart';
import 'package:bookbug/ui/home/view_model/home_page.dart';
import 'package:bookbug/ui/login/widgets/splash_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authProvider = AuthProvider();

  final shouldAutoLogin = await TokenManager.isAutoLoginEnabled();
  final savedToken = shouldAutoLogin ? await TokenManager.getToken() : null;
  final isLoggedIn = savedToken != null && savedToken.isNotEmpty;

  if (isLoggedIn) {
    await authProvider.setToken(savedToken);
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authProvider),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final isDarkMode =
            MediaQuery.platformBrightnessOf(context) == Brightness.dark;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: '책 리뷰 앱',
          theme: ThemeData(
            colorScheme: MaterialTheme.lightScheme().toColorScheme(),
            fontFamily: 'Pretendard',
          ),
          darkTheme: ThemeData(
            colorScheme: MaterialTheme.darkScheme().toColorScheme(),
            fontFamily: 'Pretendard',
          ),
          themeMode: Provider.of<ThemeProvider>(context).thememode,

          home: SplashWidget(isLoggedIn: isLoggedIn),
          routes: {
            '/login': (context) => const LoginPage(),
            '/home':
                (context) => Consumer<AuthProvider>(
                  builder: (context, auth, _) {
                    return HomePage(token: auth.token!);
                  },
                ),
          },
        );
      },
    );
  }
}
