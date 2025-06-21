import 'package:bookbug/ui/core/ui/listitem_base.dart';
import 'package:flutter/material.dart';
import 'package:bookbug/ui/book/view_model/book_detail_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ToreadListPage extends StatefulWidget {
  final String token;

  const ToreadListPage({super.key, required this.token});

  @override
  State<ToreadListPage> createState() => _ToreadListPageState();
}

class _ToreadListPageState extends State<ToreadListPage> {
  final String baseUrl = 'https://forifbookbugapi.seongjinemong.app';

  Future<List<dynamic>> fetchBooks() async {
    final url = Uri.parse('$baseUrl/api/user');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}'
      },
    );
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      final readlist = decodedData['readlist'];
      return readlist;
    } else {
      throw Exception('데이터를 불러오지 못했습니다: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<List<dynamic>>(
          future: fetchBooks(),
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
      body: FutureBuilder<List<dynamic>>(
        future: fetchBooks(),
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
                  title: book['title'], 
                  content: '', 
                  trailingText: '',
                  leadingText: null,
                  leadingImageUrl: null,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BookDetailPage(
                        bookId: book['id'],
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