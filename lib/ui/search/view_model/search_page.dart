import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isFilterVisible = false;

  void toggleFilter() {
    setState(() {
      isFilterVisible = !isFilterVisible;
    });
  }

  final TextEditingController authorController = TextEditingController();
  final TextEditingController publisherController = TextEditingController();
  final TextEditingController tagController = TextEditingController();

  String selectedCategory = '';
  List<String> categories = ['카테고리1', '카테고리2', '카테고리3'];

  List<Map<String, dynamic>> books = List.generate(
    9,
    (index) => {
      'title': 'Book',
      'author': 'Author',
      'rating': 3.5, // 추후 이미지 추가
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: '제목',
            border: InputBorder.none,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // 검색 실행
              print('검색 실행');
            },
          ),
          IconButton(
            icon: Icon(isFilterVisible ? Icons.list : Icons.arrow_drop_down),
            onPressed: toggleFilter,
          ),
        ],
      ),
      body: Column(
        children: [
          // 상세 필터 영역
          if (isFilterVisible)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Column(
                children: [
                  TextField(
                    controller: authorController,
                    decoration: InputDecoration(labelText: '저자'),
                  ),
                  TextField(
                    controller: publisherController,
                    decoration: InputDecoration(labelText: '출판사'),
                  ),
                  TextField(
                    controller: tagController,
                    decoration: InputDecoration(labelText: '태그'),
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedCategory.isEmpty ? null : selectedCategory,
                    items: categories.map((cat) {
                      return DropdownMenuItem(
                        value: cat,
                        child: Text(cat),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value ?? '';
                      });
                    },
                    decoration: InputDecoration(labelText: '카테고리'),
                  ),
                ],
              ),
            ),

          // 책 리스트
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: books.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.6,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final book = books[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(book['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(book['author']),
                    Row(
                      children: [
                        Icon(Icons.star, size: 14, color: Colors.amber),
                        SizedBox(width: 4),
                        Text('${book['rating']}'),
                        // 추후 이미지 추가 //
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
