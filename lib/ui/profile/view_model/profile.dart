import 'dart:io';
import 'package:bookbug/ui/lists/view_model/toread_list_page.dart';
import 'package:bookbug/ui/lists/view_model/wrote_list_page.dart';
import 'package:bookbug/ui/book/view_model/book_review_detail_page.dart';
import 'package:bookbug/ui/book/view_model/book_detail_page.dart';
import 'package:bookbug/ui/book/view_model/book_review_list_page.dart';
import 'package:bookbug/ui/core/themes/theme_mode.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bookbug/ui/profile/widget/usermodel.dart';
import 'package:bookbug/ui/profile/widget/user_api.dart';
import 'package:bookbug/ui/profile/view_model/profile_edit.dart';
import 'package:bookbug/ui/lists/view_model/badge_list_page.dart';
import 'package:bookbug/ui/core/ui/bookcomponent_base.dart';
import 'package:bookbug/ui/core/ui/badgebutton_base.dart';
import 'package:bookbug/ui/core/ui/iconbutton_base.dart';
import 'package:bookbug/ui/core/ui/listitem_base.dart';
import 'package:provider/provider.dart';
import 'package:bookbug/data/services/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  Future<User>? _userFuture;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final token = context.read<AuthProvider>().token;
    if (token != null) {
      setState(() {
        _userFuture = getUserProfile(token);
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 600,
    );
    if (picked != null) {
      final file = File(picked.path);
      setState(() => _imageFile = file);
      final token = await _storage.read(key: 'token');
      if (token != null) {
        try {
          await uploadProfileImage(token, file);

          setState(() {
            _userFuture = getUserProfile(token);
          });
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('이미지 업로드 실패: \$e')));
        }
      }
    }
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("로그아웃 하시겠어요?"),
            content: const Text("떠나신다니 슬퍼요.."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("취소"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);

                  await _storage.delete(key: 'token');
                  await _storage.delete(key: 'auth_token');

                  if (!mounted) return;
                  Provider.of<AuthProvider>(context, listen: false).logout();

                  if (!mounted) return;
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/login', (route) => false);
                },
                child: const Text("로그아웃"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final token = context.read<AuthProvider>().token;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          CircleIconButton(
            icon: Icons.bookmark,
            size: 40,
            iconSize: 20,
            onPressed: () {
              if (token != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ToreadListPage(token: token),
                  ),
                );
              }
            },
          ),
          const SizedBox(width: 8),
          CircleIconButton(
            icon: Icons.dark_mode,
            size: 40,
            iconSize: 20,
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
          ),
          const SizedBox(width: 8),
          CircleIconButton(
            icon: Icons.logout,
            size: 40,
            iconSize: 20,
            onPressed: () => _confirmLogout(context),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: FutureBuilder<User>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('에러: \${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('사용자 정보가 없습니다.'));
          }
          var user = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          _imageFile != null
                              ? FileImage(_imageFile!)
                              : (user.image?.isNotEmpty == true
                                      ? NetworkImage(user.image!)
                                      : const AssetImage(
                                        'assets/defaultimage.png',
                                      ))
                                  as ImageProvider,
                      child:
                          _imageFile == null && (user.image?.isEmpty ?? true)
                              ? const Icon(
                                Icons.add_a_photo,
                                size: 24,
                                color: Colors.white70,
                              )
                              : null,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Profile 위젯 내부 build 메서드에서
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push<User>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProfileEdit(user: user),
                        ),
                      ).then((updatedUser) {
                        // 수정 완료 후 updatedUser가 null이 아닐 때만 setState
                        if (updatedUser != null) {
                          setState(() {
                            // Profile 화면의 user를 갱신
                            user = updatedUser;
                          });
                        }
                      });
                    },
                    child: const Text('수정하기'),
                  ),
                ),

                const SizedBox(height: 20),
                Center(
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(child: booksection(context, '최애 책', user)),
                      Expanded(child: badgesection(context, '뱃지(0)')),
                    ],
                  ),
                ),

                wrotereview(context, '작성한 리뷰'),
                likedreview(context, '좋아요한 리뷰'),
              ],
            ),
          );
        },
      ),
    );
  }

  // Original UI functions
  Widget booksection(BuildContext context, String title, User user) {
    final fav = user.favoriteBook;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SizedBox(
            height: 260,
            width: 160,
            child:
                fav != null
                    ? GestureDetector(
                      onTap: () {
                        final token = context.read<AuthProvider>().token;
                        if (token != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => BookDetailPage(
                                    bookId: fav.id,
                                    token: token,
                                  ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('로그인된 토큰이 없습니다.')),
                          );
                        }
                      },
                      child: BookCard(
                        id: fav.id,
                        title: fav.title,
                        author: fav.author,
                        rating: fav.rating,
                        imageUrl: fav.imageUrl,
                        onTap: () {
                          final token = context.read<AuthProvider>().token;
                          if (token != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => BookDetailPage(
                                      bookId: fav.id,
                                      token: token,
                                    ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('로그인된 토큰이 없습니다.')),
                            );
                          }
                        },
                      ),
                    )
                    : Container(
                      height: 260,
                      width: 160,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(25),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          '최애 책이 없습니다.\n수정 화면에서 설정하세요.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
          ),
        ),
      ],
    );
  }

  Widget badgesection(BuildContext context, String title) {
    const badgeAsset = 'assets/basic_profile_4.jpeg';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            height: 260,
            width: 160,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(25),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: BadgebuttonBase(badge: badgeAsset, badgename: '시작이 반이다'),
                ),
                const Spacer(),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: TextButton(
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (builder) => BadgeListPage(),
                          ),
                        ),
                    child: const Row(
                      children: [
                        Text('더보기'),
                        Spacer(),
                        Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget wrotereview(BuildContext context, String title) {
    const baseUrl = 'https://forifbookbugapi.seongjinemong.app';

    // 1) 리뷰를 가져오는 Future 함수
    Future<List<dynamic>> fetchReviews() async {
      final token = context.read<AuthProvider>().token;
      if (token == null) throw Exception('로그인 토큰이 없습니다.');

      // 사용자 ID 조회
      final profileRes = await http.get(
        Uri.parse('$baseUrl/api/user'),
        headers: {'Authorization': 'Bearer $token'},
      );
      final userId = jsonDecode(profileRes.body)['id'];

      // 내가 쓴 리뷰 목록 조회
      final res = await http.get(
        Uri.parse('$baseUrl/api/reviews/user/$userId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (res.statusCode != 200) {
        throw Exception('리뷰 데이터를 불러오지 못했습니다: ${res.body}');
      }
      return jsonDecode(res.body) as List<dynamic>;
    }

    // 2) FutureBuilder 로 감싸서 비동기 결과 처리
    return FutureBuilder<List<dynamic>>(
      future: fetchReviews(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(child: Text('에러: ${snap.error}'));
        }
        final reviews = snap.data!;
        final token = context.read<AuthProvider>().token;
        if (token == null) {
          return Center(child: Text('로그인이 필요합니다.'));
        }

        // 3) 실제 UI
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 제목과 “더보기” 버튼
              Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () {
                      final token = context.read<AuthProvider>().token;
                      if (token != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WroteListPage(token: token),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('로그인된 토큰이 없습니다.')),
                        );
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 8),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 2,
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return ListItem(
                    nickname: review['author']['username'] ?? '',
                    title: review['title'] ?? '',
                    content: review['description'] ?? '',
                    leadingText:
                        (review['author']['username'] ?? 'U')[0].toUpperCase(),
                    trailingText: '${review['_count']['likedBy'] ?? 0}',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => BookReviewDetailPage(
                                reviewId: review['id'],
                                bookId: review['bookId'],
                                token: token,
                              ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget likedreview(BuildContext context, String title) {
    const baseUrl = 'https://forifbookbugapi.seongjinemong.app';

    // 1) 리뷰를 가져오는 Future 함수
    Future<List<dynamic>> fetchReviews() async {
      final token = context.read<AuthProvider>().token;
      if (token == null) throw Exception('로그인 토큰이 없습니다.');

      // 사용자 ID 조회
      final profileRes = await http.get(
        Uri.parse('$baseUrl/api/user'),
        headers: {'Authorization': 'Bearer $token'},
      );
      final userId = jsonDecode(profileRes.body)['id'];

      // 내가 쓴 리뷰 목록 조회
      final res = await http.get(
        Uri.parse('$baseUrl/api/reviews/user/$userId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (res.statusCode != 200) {
        throw Exception('리뷰 데이터를 불러오지 못했습니다: ${res.body}');
      }
      return jsonDecode(res.body) as List<dynamic>;
    }

    // 2) FutureBuilder 로 감싸서 비동기 결과 처리
    return FutureBuilder<List<dynamic>>(
      future: fetchReviews(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(child: Text('에러: ${snap.error}'));
        }
        final reviews = snap.data!;

        // 3) 실제 UI
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 제목과 “더보기” 버튼
              Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () {
                      final token = context.read<AuthProvider>().token;
                      if (token != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WroteListPage(token: token),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('로그인된 토큰이 없습니다.')),
                        );
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // 4) ListView.builder 에 실제 리뷰 배열 사용
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 2,
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return ListItem(
                    nickname: review['author']['username'] ?? '',
                    title: review['title'] ?? '',
                    content: review['description'] ?? '',
                    leadingText:
                        (review['author']['username'] ?? 'U')[0].toUpperCase(),
                    trailingText: '${review['_count']['likedBy'] ?? 0}',
                    onTap: () {
                      // 상세 페이지 이동 로직
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
