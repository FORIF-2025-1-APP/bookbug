import 'package:flutter/material.dart';

class BookinfoBase extends StatelessWidget {
  late ImageProvider imageProvider;
  final String author;
  final String title;
  final String publisher;
  final String pubDate;

  BookinfoBase({
    required this.imageProvider,
    required this.author,
    required this.title,
    required this.publisher,
    required this.pubDate,
    super.key,
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
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Image(image: imageProvider, width: 74, height: 104),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.scrim,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Text(
                author,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: colorScheme.scrim,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Text(
                publisher,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: colorScheme.scrim,
                ),
                selectionColor: colorScheme.inversePrimary,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Text(
                pubDate,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: colorScheme.scrim,
                ),
                selectionColor: colorScheme.inversePrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
