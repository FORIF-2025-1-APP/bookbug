import 'dart:io';

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

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<Profile> {
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
    final token = await _storage.read(key: 'token');
    if (token != null) {
      _userFuture = getUserProfile(token);
      setState(() {});
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
          _userFuture = getUserProfile(token);
          setState(() {});
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
          (_) => AlertDialog(
            title: const Text("로그아웃 하시겠어요?"),
            content: const Text("떠나신다니 슬퍼요.."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("취소"),
              ),
              TextButton(
                onPressed: () {
                  _storage.delete(key: 'accessToken');
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text("로그아웃"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          CircleIconButton(
            icon: Icons.bookmark,
            size: 40,
            iconSize: 20,
            onPressed: () {},
          ),
          SizedBox(width: 10),
          CircleIconButton(
            icon: Icons.dark_mode,
            size: 40,
            iconSize: 20,
            onPressed: () {},
          ),
          SizedBox(width: 10),
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
          final user = snapshot.data!;
          return _buildProfileBody(context, user);
        },
      ),
    );
  }

  Widget _buildProfileBody(BuildContext context, User user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 50,
              backgroundImage:
                  _imageFile != null
                      ? FileImage(_imageFile!)
                      : (user.image != null && user.image!.isNotEmpty)
                      ? NetworkImage(user.image!)
                      : const AssetImage('assets/hyu.jpeg') as ImageProvider,
              child:
                  _imageFile == null &&
                          (user.image == null || user.image!.isEmpty)
                      ? const Icon(
                        Icons.add_a_photo,
                        size: 24,
                        color: Colors.white70,
                      )
                      : null,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            user.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(user.email, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            '가입일: \${user.createdAt.toLocal().toString().split('
            ').first}',
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileEdit()),
                ),
            child: const Text('프로필 수정'),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: BookCard(
                  title: "title",
                  author: "author",
                  rating: 5,
                  imageUrl: 'imageUrl',
                ),
              ),
              Expanded(child: _badgeSection(context, '뱃지(0)')),
            ],
          ),
          _reviewSection(context, '작성한 리뷰'),
          _reviewSection(context, '좋아요한 리뷰'),
        ],
      ),
    );
  }

  Widget _badgeSection(BuildContext context, String title) {
    const badgeAsset = 'assets/hyu.jpeg';
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
        Container(
          height: 260,
          width: 160,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF0EFE1),
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
                child: BadgebuttonBase(badge: badgeAsset, badgename: 'HYU'),
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
                          builder: (_) => const BadgeListPage(),
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
      ],
    );
  }

  Widget _reviewSection(BuildContext context, String title) {
    final reviews = [
      {
        'nickname': 'nick',
        'title': 'title',
        'content': 'content',
        'leadingText': 'A',
        'trailingText': '30',
      },
      {
        'nickname': 'nick',
        'title': 'title',
        'content': 'content',
        'leadingText': 'A',
        'trailingText': '100+',
      },
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reviews.length,
            itemBuilder: (ctx, i) {
              final r = reviews[i];
              return ListItem(
                nickname: r['nickname']!,
                title: r['title']!,
                content: r['content']!,
                leadingText: r['leadingText'],
                leadingImageUrl: r['leadingImageUrl'],
                trailingText: r['trailingText']!,
                onTap: () {},
              );
            },
          ),
          const SizedBox(
            height: 40,
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.arrow_forward),
            ),
          ),
        ],
      ),
    );
  }
}
