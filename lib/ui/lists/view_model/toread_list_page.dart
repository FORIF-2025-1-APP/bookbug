import 'package:bookbug/ui/core/ui/listitem_base.dart';
import 'package:flutter/material.dart';
import 'package:bookbug/ui/book/view_model/book_detail_page.dart';

class ToreadListPage extends StatelessWidget {
  const ToreadListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final books = List.generate(15, (index) => {
      'title': 'List item',
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('읽을 책(${books.length})'),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(), 
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          final book = books[index];
          return ListItem(
            nickname: '', 
            title: book['title']!, 
            content: '', 
            trailingText: '',
            leadingText: null,
            leadingImageUrl: null,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookDetailPage(bookId: book[id],)),
              );
            },
            contentWidget: const SizedBox.shrink(),
            titleWidget: Text(
              book['title']!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }, 
        separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.transparent), 
        itemCount: books.length,
      ),
    );
  }
}