import 'package:flutter/material.dart';
import 'package:bookbug/ui/core/ui/listitem_base.dart';
import 'package:bookbug/ui/core/ui/tag_base.dart';

class BookDetailPage extends StatefulWidget{
  const BookDetailPage({super.key});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage>{

  void _addToBookmark(){
    // DB 연결 시 추가 예정
  }

  void _setToFavoriteBook(){
    // DB 연결 시 추가 예정
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('상세정보'),
        actions: [
          IconButton(
            onPressed: _setToFavoriteBook, 
            icon: const Icon(Icons.collections_bookmark),
            tooltip: '최애 책 지정',
          ),
          IconButton(
            onPressed: _addToBookmark, 
            icon: const Icon(Icons.bookmark),
            tooltip: '북마크',
          ),
        ],
      ),
      body: Column(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 132,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Image(image: AssetImage(''), width: 116, height: 163),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                  child: Text('title', style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ))
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                  child: Text('author', style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Colors.black
                  ))
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                  child: Text('publisher.pubDate', style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).colorScheme.primaryContainer
                  ))
                ),
                Row(
                  children: [
                    TagBase(tagName: 'tag1'),
                    TagBase(tagName: 'tag2'),
                    TagBase(tagName: 'tag3'),
                    TagBase(tagName: 'tag4'),
                    TagBase(tagName: 'tag5'),
                  ],
                )
                // 별점은 DB 연결 후 한번에 추가 예정
              ],
            ),
          ),
          reviewsection(context, '리뷰')
        ],
      )
    );
  }

  Widget reviewsection(BuildContext context, String title) {
    final List<Map<String, String>> reviews = [
      {
        'nickname': 'nickname',
        'title': 'title',
        'content': 'content',
        'leadingText': 'A',
        'trailingText': '30',
      },
      {
        'nickname': 'nickname',
        'title': 'title',
        'content': 'content',
        'leadingText': 'A',
        'trailingText': '100+',
      },
    ];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children:[
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Text(
                '57',// 임시 할당
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black),
              ),
            ],
          ),
          SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return ListItem(
                nickname: review['nickname'] ?? '',
                title: review['title'] ?? '',
                content: review['content'] ?? '',
                leadingText: review['leadingText'],
                leadingImageUrl: review['leadingImageUrl'],
                trailingText: review['trailingText'] ?? '',
                onTap: () {},
              );
            },
          ),
          SizedBox(
            height: 40,
            child: TextButton(
              onPressed: () {},
              child: Row(
                children: [Text('더보기'), Spacer(), Icon(Icons.arrow_forward)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}