import 'package:flutter/material.dart';

class TagBase extends StatelessWidget {
  final String tagName;
  const TagBase({required this.tagName, super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    ButtonStyle style = ElevatedButton.styleFrom(
      backgroundColor: colorScheme.inversePrimary,
      minimumSize: Size(10, 25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

    return ButtonTheme(
      child: ElevatedButton(
        onPressed: () {},
        style: style,
        child: Text(tagName, style: TextStyle(
          fontSize: 10,
        )),
      ),
    );
  }
}
