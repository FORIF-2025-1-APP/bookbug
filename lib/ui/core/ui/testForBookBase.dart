import 'package:flutter/material.dart';
import './bookInfo_Base.dart';
import './contentText_Base.dart';
import './tag_Base.dart';

class Testforbookbase extends StatefulWidget{
  const Testforbookbase({super.key});

  @override
  State<Testforbookbase> createState() => _TestpageState();
}

class _TestpageState extends State<Testforbookbase> {
  @override
  Widget build(BuildContext context) {
    final myCon = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('test')
      ),
      body: Center(
        child: Column(
          children: [
            BookinfoBase(
              imageProvider: AssetImage(''), //비워 뒀습니다.
              author: 'author', 
              title: 'title', 
              publisher: 'publisher', 
              pubDate: 'pubDate', 
              review: 'review'
            ),
            ContentTextBase(
              height: 238,
              label: 'label',
              controller: myCon
            ),
            TagBase(tagName: 'tagName')
          ],
        )
      )
    );
  }
}