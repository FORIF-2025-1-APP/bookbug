import 'package:flutter/material.dart';

class ContentTextBase extends StatelessWidget {
  final double height;
  final double width;
  final String label;
  final bool autofocus;
  final TextEditingController? controller;

  const ContentTextBase({
    required this.height,
    this.width = 343,
    required this.label,
    this.autofocus = false,
    required this.controller,
    super.key
  });

  @override
  Widget build(BuildContext context){
    final ThemeData theme = Theme.of(context);

    return SizedBox(
      width: width,
      height: height,
      child: Expanded(
        child: TextField(
          expands: true,
          maxLines: null,
          textAlignVertical: TextAlignVertical(y: -1),
          autofocus:autofocus,
          controller: controller,
          decoration: InputDecoration(
    	      border: OutlineInputBorder(
              borderSide: BorderSide(
                color: theme.primaryColor,
                width: 1.0
              )
            ),
    	    labelText: label,
          )
        )
      )
    );
  }
}