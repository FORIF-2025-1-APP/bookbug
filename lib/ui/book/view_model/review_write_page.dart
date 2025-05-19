import 'package:flutter/material.dart';
import 'package:bookbug/ui/core/ui/contenttext_base.dart';
import 'package:bookbug/ui/core/ui/bookinfo_base.dart';
import 'package:bookbug/ui/core/ui/popup_base.dart';

class ReviewWritePage extends StatefulWidget {
  const ReviewWritePage({super.key});

  @override
  State<ReviewWritePage> createState() => _ReviewWritePageState();
}

class _ReviewWritePageState extends State<ReviewWritePage> {
  late final TextEditingController controllerTitle;
  late final TextEditingController controllerMain;
  late final TextEditingController controllerTag;

  @override
  void initState() {
    super.initState();
    controllerTitle = TextEditingController();
    controllerMain = TextEditingController();
    controllerTag = TextEditingController();
  }

  @override
  void dispose() {
    controllerTitle.dispose();
    controllerMain.dispose();
    controllerTag.dispose();
    super.dispose();
  }

  void _addTag(String t) {
    // DB 연결 후 추가 예정
  }

  void _immSave() {
    // DB 연결 후 추가 예정
  }

  void _reviewCancel() {
    showDialog(
      context: context,
      builder: (_) => PopUpCard(
        title: '글 작성을 취소하시겠어요?',
        description:
            '임시저장하실 경우 현재 진행 내역이 저장됩니다. \n삭제하실 경우 모든 내용이 지워집니다.',
        leftButtonText: '임시 저장',
        rightButtonText: '삭제',
        onRightPressed: () => Navigator.of(context).pop(),
        onLeftPressed: () {
          _immSave();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('리뷰 작성 (수정)',
            style: Theme.of(context).textTheme.titleLarge),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _reviewCancel,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BookinfoBase(
              imageProvider: const AssetImage('assets/images/placeholder.png'),
              author: 'author',
              title: 'title',
              publisher: 'publisher',
              pubDate: 'pubDate',
              review: 'review',
            ),
            const SizedBox(height: 16),
            ContentTextBase(
              label: '리뷰 제목',
              controller: controllerTitle,
            ),
            const SizedBox(height: 16),
            ContentTextBase(
              height: size.height * 0.3,
              label: '본문',
              controller: controllerMain,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controllerTag,
                    maxLines: 1,
                    decoration: InputDecoration(
                      labelText: '태그',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    _addTag(controllerTag.text);
                    controllerTag.clear();
                  },
                  child: const Text('추가'),
                )
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // 완료 처리 로직 추가 예정
                },
                child: const Text('완료'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}