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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );

    return ButtonTheme(
      minWidth: 32,
      height: 32,
      child: ElevatedButton(
        onPressed: () {},
        style: style,
        child: Text(tagName, style: theme.textTheme.bodySmall),
      ),
    );
  }
}
