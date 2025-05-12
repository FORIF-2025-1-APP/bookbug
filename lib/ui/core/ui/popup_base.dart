import 'package:flutter/material.dart';

class PopUpCard extends StatelessWidget {
  final String title;
  final String? description;
  final String leftButtonText;
  final String rightButtonText;
  final VoidCallback onLeftPressed;
  final VoidCallback onRightPressed;

  const PopUpCard({
    super.key,
    required this.title,
    this.description,
    required this.leftButtonText,
    required this.rightButtonText,
    required this.onLeftPressed,
    required this.onRightPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color:Theme.of(context).colorScheme.surfaceContainerHigh, // 카드 배경
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            if (description != null) ...[
              const SizedBox(height: 8),
              Text(
                description!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onLeftPressed,
                  child: Text(
                    leftButtonText,
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: onRightPressed, 
                  child: Text(rightButtonText),
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
}