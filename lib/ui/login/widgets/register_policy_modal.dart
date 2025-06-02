import 'package:flutter/material.dart';

class RegisterPolicyModal extends StatefulWidget {
  final String title;
  final String content;
  final bool isChecked;

  const RegisterPolicyModal({
    super.key,
    required this.title,
    required this.content,
    required this.isChecked,
  });

  @override
  State<RegisterPolicyModal> createState() => _RegisterPolicyModalState();
}

class _RegisterPolicyModalState extends State<RegisterPolicyModal> {
  late bool checked;

  @override
  void initState() {
    super.initState();
    checked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 1,
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: checked,
                    onChanged: (val) {
                      if (val == true && checked == false) {
                        Navigator.pop(context, true);
                      } else {
                        setState(() {
                          checked = val ?? false;
                        });
                      }
                    },
                  ),
                  const Text('동의합니다'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const String termsOfUse = '''
[가입약관]

1. 목적
이 약관은 BOOKBUG 앱에서 제공하는 도서 정보 공유 서비스 이용과 관련된 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.

2. 정의
- "회원": 본 약관에 따라 서비스 이용 계약을 체결한 자
- "콘텐츠": 회원이 작성한 도서 리뷰 및 정보

3. 이용자의 의무
- 타인의 정보 도용 금지
- 불법 콘텐츠 게시 금지 등

4. 면책사항
운영자는 회원이 게시한 정보의 신뢰성에 대해 책임지지 않습니다.
''';

const String privacyPolicy = '''
[개인정보 수집 및 이용 동의]

1. 수집 항목
- 이메일, 비밀번호, 닉네임

2. 수집 목적
- 회원 식별 및 서비스 제공

3. 보유 기간
- 회원 탈퇴 시까지 (단, 관련 법령에 따라 일정 기간 보관 가능)
''';