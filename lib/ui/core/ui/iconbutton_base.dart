import 'package:flutter/material.dart';

/// 원형 아이콘 버튼 위젯
class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final double iconSize;

  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 60.0,
    this.iconSize = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    final _ = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}

/// 여러 CircleIconButton을 가로로 배치하는 위젯
class CircleIconButtonRow extends StatelessWidget {
  final List<CircleIconButton> buttons;
  final double spacing;
  final EdgeInsets padding;

  const CircleIconButtonRow({
    super.key,
    required this.buttons,
    this.spacing = 12.0,
    this.padding = const EdgeInsets.all(12.0),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _buildButtonsWithSpacing(),
      ),
    );
  }

  List<Widget> _buildButtonsWithSpacing() {
    final List<Widget> result = [];

    for (int i = 0; i < buttons.length; i++) {
      result.add(buttons[i]);
      if (i < buttons.length - 1) {
        result.add(SizedBox(width: spacing));
      }
    }

    return result;
  }
}
