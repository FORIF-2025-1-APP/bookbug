import 'package:flutter/material.dart';

class TokenBase extends StatefulWidget {
  final String token;
  final Widget child;

  const TokenBase({
    Key? key,
    required this.token,
    required this.child,
  }) : super(key: key);

  @override
  _TokenBaseState createState() => _TokenBaseState();

  static _TokenBaseState of(BuildContext context) {
    return context.findAncestorStateOfType<_TokenBaseState>()!;
  }
}

class _TokenBaseState extends State<TokenBase> {
  late String _token;

  @override
  void initState() {
    super.initState();
    _token = widget.token;
  }

  void updateToken(String newToken) {
    setState(() {
      _token = newToken;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InheritedToken(
      token: _token,
      child: widget.child,
    );
  }
}

class InheritedToken extends InheritedWidget {
  final String token;

  const InheritedToken({
    Key? key,
    required this.token,
    required Widget child,
  }) : super(key: key, child: child);

  static String of(BuildContext context) {
    final InheritedToken? result =
        context.dependOnInheritedWidgetOfExactType<InheritedToken>();
    return result?.token ?? '';
  }

  @override
  bool updateShouldNotify(InheritedToken oldWidget) {
    return oldWidget.token != token;
  }
}
