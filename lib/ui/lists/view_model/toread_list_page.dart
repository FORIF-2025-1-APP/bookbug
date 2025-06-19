import 'package:bookbug/ui/core/ui/listitem_base.dart';
import 'package:flutter/material.dart';
import 'package:bookbug/ui/book/view_model/book_detail_page.dart';
import 'package:bookbug/data/model/book_model.dart';
import 'package:bookbug/data/services/api_service.dart';

class ToreadListPage extends StatefulWidget {
  final String token;

  const ToreadListPage({super.key, required this.token});

  @override
  State<ToreadListPage> createState() => _ToreadListPageState();
}

class _ToreadListPageState extends State<ToreadListPage> {
  Future<List<Book>>? _bookListFuture;

  @override
  void initState() {
    super.initState();
    _bookListFuture = ApiService.getToReadList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<List<Book>>(
          future: _bookListFuture,
          builder: (context, snapshot) {
            final count = snapshot.hasData ? snapshot.data!.length : 0;
            return Text('읽을 책($count)');
          },
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: FutureBuilder<List<Book>>(
        future: _bookListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('에러: ${snapshot.error}'));
          } else {
            final books = snapshot.data!;
            return ListView.separated(
              itemCount: books.length,
              separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.transparent),
              itemBuilder: (context, index) {
                final book = books[index];
                return ListItem(
                  nickname: '', 
                  title: book.title, 
                  content: '', 
                  trailingText: '',
                  leadingText: null,
                  leadingImageUrl: null,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BookDetailPage(
                        bookId: (book.id).toString(),
                        token: widget.token
                        ),
                      ),
                    );
                  },
                  contentWidget: const SizedBox.shrink(),
                  titleWidget: Text(
                    book.title,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}