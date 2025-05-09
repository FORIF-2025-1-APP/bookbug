import 'package:flutter/material.dart';

class PagetitleBase extends StatelessWidget {
  final String title;
  final double fontsize;
  final Color? color;
  final TextAlign align;
  final EdgeInsetsGeometry padding;

  const PagetitleBase({
    super.key,
    required this.title,
    this.fontsize = 20,
    this.color,
    this.align = TextAlign.left,
    this.padding = const EdgeInsets.all(8.0),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        title,
        textAlign: align,
        style: TextStyle(
          fontSize: fontsize,
          color: color ?? Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
