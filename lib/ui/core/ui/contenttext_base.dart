import 'package:flutter/material.dart';

class ContentTextBase extends StatelessWidget {
  final double height;
  final String label;
  final bool autofocus;
  final TextEditingController? controller;

  const ContentTextBase({
    this.height = 56,
    required this.label,
    this.autofocus = false,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: height,
      width: double.infinity,
      child: TextField(
        expands: true,
        maxLines: null,
        minLines: null,
        autofocus: autofocus,
        controller: controller,
        textAlignVertical: TextAlignVertical(y: -1),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(12),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: theme.primaryColor, width: 1.0),
          ),
          labelText: label,
        ),
      ),
    );
  }
}