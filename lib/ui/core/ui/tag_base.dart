import 'package:flutter/material.dart';

class TagBase extends StatelessWidget {
  final String tagName;
  const TagBase({required this.tagName, super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 0),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.inversePrimary,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: Size(10, 36),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          tagName,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}