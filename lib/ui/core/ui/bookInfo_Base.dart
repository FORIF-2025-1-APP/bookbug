import 'package:flutter/material.dart';

class BookinfoBase extends StatelessWidget {
  late ImageProvider imageProvider;
  final String author;
  final String title;
  final String publisher;
  final String pubDate;
  final String review;

  BookinfoBase({
    required this.imageProvider,
    required this.author,
    required this.title,
    required this.publisher,
    required this.pubDate,
    required this.review,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Row(
      children: [
        Container(
          width: 84,
          height: 115,
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(
              Radius.circular(20)
            )
          ),
          child: Image(
            image: imageProvider,
            width: 74,
            height: 104
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Text(title,
                style: theme.textTheme.headlineMedium)
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Text(author,
                style: theme.textTheme.bodyMedium)
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Text('$publisher.$pubDate', 
                style: TextStyle(color: colorScheme.inversePrimary),
                selectionColor: colorScheme.inversePrimary)
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Text(review, 
                style: TextStyle(color: colorScheme.inversePrimary),
                selectionColor: colorScheme.inversePrimary)
            ),
          ],
        )
      ],
    );
  }
}