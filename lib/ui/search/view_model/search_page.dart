import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bookbug/ui/book/view_model/book_detail_page.dart';

class SearchPage extends StatefulWidget {
  final String token;
  const SearchPage({super.key, required this.token});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isFilterVisible = false;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController publisherController = TextEditingController();
  final TextEditingController tagController = TextEditingController();

  String selectedCategory = '';
  List<String> categories = ['카테고리1', '카테고리2', '카테고리3'];
  List<Map<String, dynamic>> books = [];
  bool _isLoading = false;

  void toggleFilter() {
    setState(() => isFilterVisible = !isFilterVisible);
  }

  Future<void> _searchBooks() async {
    final title = titleController.text.trim();
    final author = authorController.text.trim();
    final publisher = publisherController.text.trim();
    final tag = tagController.text.trim();
    final category = selectedCategory;

    if ([title, author, publisher, tag, category].every((e) => e.isEmpty)) return;

    setState(() => _isLoading = true);

    final queryParameters = {
      'query': title,
      'author': author,
      'publisher': publisher,
      'tag': tag,
      'category': category,
    }..removeWhere((key, value) => value.isEmpty);

    final uri = Uri.https('forifbookbugapi.seongjinemong.app', '/api/books', queryParameters);

    debugPrint('🔍 검색 요청: $uri');

    final response = await http.get(
      uri,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      debugPrint('📡 응답 내용: ${response.body}');
      setState(() {
        final rawBooks = data['books'] ?? data['items'] ?? [];
        books = List<Map<String, dynamic>>.from(rawBooks);
        _isLoading = false;
      });
    } else {
      debugPrint('❌ 검색 실패: ${response.body}');
      setState(() {
        books = [];
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('검색에 실패했습니다')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: titleController,
          decoration: const InputDecoration(hintText: '제목', border: InputBorder.none),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: _searchBooks),
          IconButton(
            icon: Icon(isFilterVisible ? Icons.list : Icons.arrow_drop_down),
            onPressed: toggleFilter,
          ),
        ],
      ),
      body: Column(
        children: [
          if (isFilterVisible)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Column(
                children: [
                  TextField(controller: authorController, decoration: const InputDecoration(labelText: '저자')),
                  TextField(controller: publisherController, decoration: const InputDecoration(labelText: '출판사')),
                  TextField(controller: tagController, decoration: const InputDecoration(labelText: '태그')),
                  DropdownButtonFormField<String>(
                    value: selectedCategory.isEmpty ? null : selectedCategory,
                    items: categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                    onChanged: (value) => setState(() => selectedCategory = value ?? ''),
                    decoration: const InputDecoration(labelText: '카테고리'),
                  ),
                ],
              ),
            ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : books.isEmpty
                    ? const Center(child: Text('검색 결과가 없습니다'))
                    : GridView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: books.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.6,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          final book = books[index];
                          return GestureDetector(
                            onTap: () {
                              if (book['id'] != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookDetailPage(bookId: book['id'], token: widget.token,),
                                  ),
                                );
                              }
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: book['image'] != null
                                            ? NetworkImage(book['image'])
                                            : const AssetImage('assets/images/default_book.png')
                                                as ImageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(book['title'] ?? '제목 없음', style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text(book['author'] ?? '저자 없음'),
                                Row(
                                  children: [
                                    const Icon(Icons.star, size: 14, color: Colors.amber),
                                    const SizedBox(width: 4),
                                    Text('${book['rating'] ?? 0}'),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
