import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:bookbug/ui/core/ui/profileimage_base.dart';
import 'package:bookbug/ui/profile/widget/imageedit_widget.dart';
import 'package:bookbug/ui/profile/widget/usermodel.dart'; // User 모델
import 'package:bookbug/ui/profile/widget/user_api.dart'; // API 호출
import 'package:bookbug/data/services/auth_provider.dart';

class ProfileEdit extends StatefulWidget {
  final User user;

  const ProfileEdit({
    super.key,
    required this.user, // Profile에서 받아온 user 인스턴스
  });

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final ImagePicker _picker = ImagePicker();

  // ‘수정 화면’에서 바뀐 이미지를 임시 보관할 변수
  File? _pickedImageFile;

  // 텍스트 필드 컨트롤러 (예: ID, Email, Password 등)
  late final TextEditingController _idController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _passwordConfirmController;

  @override
  void initState() {
    super.initState();

    // 1) 컨트롤러 초기화
    _idController = TextEditingController(text: widget.user.id);
    _emailController = TextEditingController(text: widget.user.email);
    _passwordController = TextEditingController();
    _passwordConfirmController = TextEditingController();
  }

  @override
  void dispose() {
    _idController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  // 갤러리/카메라에서 선택된 이미지를 임시로 보관
  Future<void> _pickImage(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 600,
    );
    if (!mounted) return;
    if (picked != null) {
      setState(() {
        _pickedImageFile = File(picked.path);
      });
    }
  }

  // 프로필 “수정 완료” 버튼 눌렀을 때 (업로드 + 서버 반영)
  Future<void> _submitChanges() async {
    // (여기에 uploadProfileImage, updateUserProfile, 다시 getUserProfile을 호출하는 로직을 구현)
    // 예시이므로 실제 본인의 user_api 함수에 맞춰 수정하세요.
    final token = context.read<AuthProvider>().token;
    if (token == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('로그인 정보가 없습니다.')));
      return;
    }

    // ① 이미지 업로드
    if (_pickedImageFile != null) {
      await uploadProfileImage(token, _pickedImageFile!);
    }
    // ② 비밀번호 변경 등 기타 프로필 정보 업데이트
    final newPassword = _passwordController.text.trim();
    final confirmPassword = _passwordConfirmController.text.trim();
    if (newPassword.isEmpty && confirmPassword.isEmpty) {
      // → 이미지 업로드만 처리하거나, “비밀번호 변경은 건너뜁니다” 로직 진행
    }
    // 4) 하나만 입력되었거나 서로 다르면 에러
    else if (newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('비밀번호와 확인 비밀번호를 모두 입력해주세요.')),
      );
      return;
    } else if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('비밀번호가 일치하지 않습니다.')));
      return;
    }

    try {
      // 6) 이미지 업로드
      if (_pickedImageFile != null) {
        await uploadProfileImage(token, _pickedImageFile!);
      }

      // 7) 비밀번호 변경 API 호출 (필요하다면 updateUserProfile에 email/id 등 다른 필드도 함께 보냄)
      if (newPassword.isNotEmpty) {
        await updateUserProfile(
          token: token,
          password: newPassword,
          // 만약 서버가 이메일 등을 요구한다면 아래처럼 추가:
          // email: _emailController.text.trim(),
          // name: widget.user.name, // 이름 변경 기능이 있다면 여기에…
        );
      }

      // 8) 업데이트 후 서버에서 최신 정보 조회
      final updatedUser = await getUserProfile(token);
      if (!mounted) return;

      // 9) (선택) 부모 화면에 변경된 정보를 반영하거나, 단순히 Pop 후 Profile 화면에서 setState를 호출하도록 설계
      // 여기서는 Pop하면서 결과를 반환할 수 있습니다:
      Navigator.pop(context, updatedUser);
      // Profile 화면에서 Navigator.push(...).then((result) { setState(() => user = result); });

      // 10) 성공 메시지
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('프로필 수정이 완료되었습니다.')));
    } catch (e) {
      // 11) API 호출 중 에러가 발생하면 메시지 출력
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('수정 중 오류가 발생했습니다: \$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // “수정 화면”에서도, 서버에서 내려온 user.image가 비어 있지 않으면 그 URL,
    // 비어 있으면 defaultimage.png(=Profile 화면과 동일)를 사용하도록 처리합니다.
    final String? serverImageUrl = widget.user.image;
    final ImageProvider displayImage =
        _pickedImageFile != null
            ? FileImage(_pickedImageFile!) as ImageProvider
            : (serverImageUrl != null && serverImageUrl.isNotEmpty
                ? NetworkImage(serverImageUrl)
                : const AssetImage('assets/defaultimage.png'));

    return Scaffold(
      appBar: AppBar(title: const Text('프로필 수정')),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // ─── 프로필 이미지 부분 ───
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(radius: 60, backgroundImage: displayImage),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          imagePickerSheet(
                            context: context,
                            defaultImage: () {
                              setState(() => _pickedImageFile = null);
                            },
                            imagePick: _pickImage,
                          );
                        },
                        child: const CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.edit,
                            size: 20,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ─── ID (읽기 전용) ───
              _buildTextField(
                controller: _idController,
                labelText: 'ID',
                readOnly: true,
                hintText: '아이디',
              ),
              const SizedBox(height: 16),

              // ─── Email (읽기 전용) ───
              _buildTextField(
                controller: _emailController,
                labelText: 'Email',
                readOnly: true,
                hintText: '이메일',
              ),
              const SizedBox(height: 16),

              // ─── 새로운 비밀번호 ───
              _buildTextField(
                controller: _passwordController,
                labelText: 'Password',
                readOnly: false,
                hintText: '새 비밀번호 입력',
                obscureText: true,
              ),
              const SizedBox(height: 16),

              // ─── 비밀번호 확인 ───
              _buildTextField(
                controller: _passwordConfirmController,
                labelText: 'Password Confirm',
                readOnly: false,
                hintText: '비밀번호 확인',
                obscureText: true,
              ),
              const SizedBox(height: 32),

              // ─── 수정 완료 버튼 ───
              SizedBox(
                width: double.infinity,
                height: 50,
                child: TextButton(
                  onPressed: _submitChanges,
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    '수정 완료',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required bool readOnly,
    required String hintText,
    bool obscureText = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color:
                  readOnly
                      ? Colors.grey.shade300
                      : Theme.of(context).colorScheme.primary,
            ),
          ),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
