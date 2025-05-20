import 'package:flutter/material.dart';

class EmptyReviewMessage extends StatelessWidget {
  final String message;

  const EmptyReviewMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}
