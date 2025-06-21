import 'dart:convert';
import 'package:bookbug/ui/book/view_model/book_detail_page.dart';
import 'package:bookbug/ui/core/ui/bookcomponent_base.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  bool _isLoading = false;
  List<BookCard> books = [];

  void toggleFilter() {
    setState(() => isFilterVisible = !isFilterVisible);
  }

  Future<void> _searchBooks() async {
    final title = titleController.text.trim();
    final author = authorController.text.trim();
    final publisher = publisherController.text.trim();
    final tag = tagController.text.trim();
    final category = selectedCategory;

    if ([title, author, publisher, tag, category].every((e) => e.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('최소 한 글자 이상 입력하세요')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final queryParameters = {
      if (title.isNotEmpty) 'title': title,
      if (author.isNotEmpty) 'author': author,
      if (publisher.isNotEmpty) 'publisher': publisher,
      if (tag.isNotEmpty) 'tag': tag,
      if (category.isNotEmpty) 'category': category,
    };

    final uri = Uri.parse('https://forifbookbugapi.seongjinemong.app/api/books/filtered')
        .replace(queryParameters: queryParameters);
    debugPrint('검색 요청: $uri');

    final response = await http.get(
      uri,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      debugPrint('응답 내용: ${response.body}');
      List<dynamic> raw = [];
      if (data is Map<String, dynamic>) {
        raw = data['items'] ?? data['books'] ?? [];
      } else if (data is List) {
        raw = data;
      }
      setState(() {
        books = raw.map((e) => BookCard.fromJson(e)).toList();
        _isLoading = false;
      });
    } else {
      debugPrint('검색 실패: ${response.body}');
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
          decoration: InputDecoration(
            hintText: '제목',
            hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
            border: InputBorder.none,
          ),
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
                    : Padding(
                        padding: const EdgeInsets.all(12),
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.6,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: books.length,
                          itemBuilder: (context, index) {
                            final bookCard = books[index];
                            return BookCard(
                              id: bookCard.id,
                              title: bookCard.title,
                              author: bookCard.author,
                              rating: bookCard.rating,
                              imageUrl: bookCard.imageUrl,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BookDetailPage(
                                    bookId: bookCard.id,
                                    token: widget.token,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
