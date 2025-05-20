import 'package:flutter/material.dart';
import 'package:bookbug/ui/core/ui/listitem_base.dart';
import 'package:bookbug/ui/core/ui/bookinfo_base.dart';
import 'package:bookbug/ui/core/ui/tag_base.dart';
import 'package:bookbug/ui/core/ui/profileimage_base.dart';
import 'package:bookbug/ui/book/view_model/book_reply_list_page.dart';
import 'package:bookbug/ui/book/view_model/book_reply_detail_page.dart';
import 'package:bookbug/ui/book/view_model/review_write_page.dart';

class BookReviewDetailPage extends StatefulWidget{
  const BookReviewDetailPage({super.key});

  @override
  State<BookReviewDetailPage> createState() => _BookReviewDetailPageState();
}

class _BookReviewDetailPageState extends State<BookReviewDetailPage>{

  void _editReview(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewWritePage(),
      ),
    );
    // DB 연결 시 추가 예정
  }

  void _deleteReview(){
    // DB 연결 시 추가 예정
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('리뷰 상세정보'),
        actions: [
          IconButton(
            onPressed: _editReview, 
            icon: const Icon(Icons.edit),
            tooltip: '수정',
          ),
          IconButton(
            onPressed: _deleteReview, 
            icon: const Icon(Icons.delete),
            tooltip: '삭제',
          ),
        ],
      ),
      body: Column(
        children: [
          BookinfoBase(
            imageProvider: AssetImage(''),
            author: 'author', 
            title: 'title', 
            publisher: 'publisher', 
            pubDate: 'pubDate', 
            review: 'review'
          ),
          Row(
            children: [
              ProfileimageBase(width:40, height: 40, image: ''),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Text('name', style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primaryContainer
                )),
              )
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: Text('reviewTitle', style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primaryContainer
            )),
          ),
          SizedBox(
            width: double.infinity,
            child: Text('reviewTitle', style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Theme.of(context).colorScheme.primaryContainer
            )),
          ),
          Row(
            children: [
              TagBase(tagName: 'tag1'),
              TagBase(tagName: 'tag2'),
              TagBase(tagName: 'tag3'),
              TagBase(tagName: 'tag4'),
              TagBase(tagName: 'tag5'),
            ],
          ),
          replysection(context, '댓글')
        ],
      )
    );
  }

  Widget replysection(BuildContext context, String title) {
    final List<Map<String, String>> replies = [
      {
        'nickname': 'nickname',
        'content': 'content',
        'leadingText': 'A',
        'trailingText': '30',
      },
      {
        'nickname': 'nickname',
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              Row(
                children:[
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Text(
                    '60',// 임시 할당
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black),
                  ),
                ]
              ),
              IconButton(onPressed: (){}, icon: Icon(Icons.favorite))
            ],
          ),
          SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: replies.length,
            itemBuilder: (context, index) {
              final reply = replies[index];
              return ListItem(
                nickname: reply['nickname'] ?? '',
                title: '',
                content: reply['content'] ?? '',
                leadingText: reply['leadingText'],
                leadingImageUrl: reply['leadingImageUrl'],
                trailingText: reply['trailingText'] ?? '',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookReplyDetailPage(),
                    ),
                  );
                },
              );
            },
          ),
          SizedBox(
            height: 40,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookReplyListPage(),
                  ),
                );
              },
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