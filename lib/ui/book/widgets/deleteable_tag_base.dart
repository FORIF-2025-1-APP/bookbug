import 'package:flutter/material.dart';

class DeleteableTagBase extends StatelessWidget {
  final String tagName;
  final VoidCallback onDelete;

  const DeleteableTagBase({
    required this.tagName,
    required this.onDelete,
    super.key,
  });

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
          minimumSize: const Size(10, 36),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tagName,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onDelete,
              child: const Icon(
                Icons.close,
                size: 16,
                color: Color.fromARGB(255, 133, 132, 132),
              ),
            ),
          ],
        ),
      ),
    );
  }
}