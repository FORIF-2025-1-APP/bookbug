import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bookbug/ui/core/ui/contenttext_base.dart';
import 'package:bookbug/ui/core/ui/bookinfo_base.dart';
import 'package:bookbug/ui/core/ui/popup_base.dart';
import 'package:bookbug/ui/book/widgets/deleteable_tag_base.dart';
import 'package:bookbug/ui/book/widgets/starrating_base.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewWritePage extends StatefulWidget {
  const ReviewWritePage({super.key});

  @override
  State<ReviewWritePage> createState() => _ReviewWritePageState();
}

class _ReviewWritePageState extends State<ReviewWritePage> {
  final TextEditingController controllerTitle = TextEditingController();
  final TextEditingController controllerMain = TextEditingController();
  final TextEditingController controllerTag = TextEditingController();
  double _rating = 0.0;
  List<String> _tags = [];
  String? _selectedBookId;
  Map<String, dynamic>? _selectedBookData;
  final String baseUrl = 'https://forifbookbugapi.seongjinemong.app';

  @override
  void initState() {
    super.initState();
    _loadDraft();
  }

  Future<void> _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      controllerTitle.text = prefs.getString('draft_title') ?? '';
      controllerMain.text = prefs.getString('draft_content') ?? '';
      _tags = prefs.getStringList('draft_tags') ?? [];
      _rating = prefs.getDouble('draft_rating') ?? 0.0;
    });
  }

  Future<void> _clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('draft_title');
    await prefs.remove('draft_content');
    await prefs.remove('draft_tags');
    await prefs.remove('draft_rating');
  }

  void _addTag(String tag) {
    final trimmed = tag.trim();
    if (trimmed.isEmpty || _tags.contains(trimmed)) return;
    setState(() => _tags.add(trimmed));
    controllerTag.clear();
  }

  Future<void> _immSave() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('draft_title', controllerTitle.text.trim());
    await prefs.setString('draft_content', controllerMain.text.trim());
    await prefs.setStringList('draft_tags', _tags);
    await prefs.setDouble('draft_rating', _rating);
  }

  void _reviewCancel() {
    showDialog(
      context: context,
      builder: (_) => PopUpCard(
        title: '글 작성을 취소하시겠어요?',
        description: '임시저장하실 경우 현재 진행 내역이 저장됩니다.\n삭제하실 경우 모든 내용이 지워집니다.',
        leftButtonText: '임시 저장',
        rightButtonText: '삭제',
        onLeftPressed: () {
          _immSave();
          Navigator.pop(context);
          Navigator.maybePop(context);
        },
        onRightPressed: () {
          _clearDraft();
          Navigator.pop(context);
          Navigator.maybePop(context);
        },
      ),
    );
  }

  Future<void> _submitReview() async {
    if (_selectedBookId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('책을 먼저 선택해주세요')));
      return;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/reviews'),
      headers: {'Content-Type': 'application/json'},//토큰 필요
      body: jsonEncode({
        'bookId': _selectedBookId,
        'title': controllerTitle.text.trim(),
        'content': controllerMain.text.trim(),
        'rating': _rating,
        'tags': _tags,
      }),
    );

    if (response.statusCode == 201) {
      _clearDraft();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('리뷰가 등록되었습니다')));
      Navigator.pop(context);
    } else {
      debugPrint('리뷰 등록 실패: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('리뷰 등록에 실패했습니다')));
    }
  }

  Future<void> _openBookSearchPopup() async {
    //임시 토큰 파트 시작
      String token = '';
      final urlL = Uri.parse('$baseUrl/api/auth/login');
      final response = await http.post(
        urlL,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({"email": "user@example.com", "password": "string"})
      );

      if(response.statusCode == 200){
        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.body}');

        try{
          final decodedData = jsonDecode(response.body);
          print('Decoded JSON: $decodedData');
          token = decodedData['token'];
        } catch(e){
          print('failed to decode JSON: $e');
        }
      } else{

      }
      //임시 토큰 파트 끝

    String query = '';
    List<Map<String, dynamic>> results = [];

    Future<void> _searchBooks(
      String keyword,
      void Function(void Function()) setDialogState,
    ) async {
      try {
        final res = await http.get(Uri.parse('$baseUrl/api/books?query=$keyword'),
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        );
        if (res.statusCode == 200) {
          final Map<String, dynamic> decoded = jsonDecode(res.body);
          final List<Map<String, dynamic>> extracted =
              List<Map<String, dynamic>>.from(decoded['items']);
          setDialogState(() => results = extracted);
        } else {
          debugPrint('검색 실패: ${res.body}');
          setDialogState(() => results = []);
        }
      } catch (e) {
        debugPrint('검색 예외: $e');
        setDialogState(() => results = []);
      }
    }

    final selected = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('도서 검색'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(hintText: '도서명 입력'),
                    onChanged: (value) {
                      query = value.trim();
                      if (query.length >= 2) {
                        _searchBooks(query, setDialogState);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200,
                    width: 300,
                    child: results.isEmpty
                        ? const Center(child: Text('검색 결과가 없습니다'))
                        : ListView.builder(
                            itemCount: results.length,
                            itemBuilder: (context, index) {
                              final book = results[index];
                              return ListTile(
                                title: Text(book['title'] ?? ''),
                                subtitle: Text(book['author'] ?? ''),
                                onTap: () => Navigator.pop(context, book),
                              );
                            },
                          ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('닫기'),
                ),
              ],
            );
          },
        );
      },
    );

    if (selected != null) {
      setState(() {
        _selectedBookId = selected['isbn'];
        _selectedBookData = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('리뷰 작성'),
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
            Row(
              children: [
                const Text('책 정보', style: TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                TextButton(
                  onPressed: _openBookSearchPopup,
                  child: const Text('도서 검색'),
                )
              ],
            ),
            const SizedBox(height: 8),
            if (_selectedBookData != null)
              BookinfoBase(
                imageProvider: _selectedBookData?['image'] != null &&
                        _selectedBookData!['image'].toString().isNotEmpty
                    ? NetworkImage(_selectedBookData!['image'])
                    : const AssetImage('assets/images/placeholder.png'),
                author: _selectedBookData?['author'] ?? '',
                title: _selectedBookData?['title'] ?? '',
                publisher: _selectedBookData?['publisher'] ?? '',
                pubDate: _selectedBookData?['pubDate'] ?? '',
                review: '',
              ),
            const SizedBox(height: 16),
            ContentTextBase(
              label: '리뷰 제목',
              controller: controllerTitle,
            ),
            const SizedBox(height: 8),
            StarRatingBase(
              rating: _rating,
              onRatingChanged: (val) => setState(() => _rating = val),
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
                    decoration: const InputDecoration(labelText: '태그'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _addTag(controllerTag.text),
                  child: const Text('추가'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _tags.map((tag) {
                return DeleteableTagBase(
                  tagName: tag,
                  onDelete: () => setState(() => _tags.remove(tag)),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitReview,
              child: const Text('완료'),
            ),
          ],
        ),
      ),
    );
  }
}