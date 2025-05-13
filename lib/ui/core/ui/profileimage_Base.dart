import 'package:flutter/material.dart';

class ProfileimageBase extends StatelessWidget {
  final String image;
  final String? badge; // 프로필 좌측 상단 뱃지는 선택
  final double width;
  final double height;

  const ProfileimageBase({
    super.key,
    required this.image,
    this.height = 100.0,
    this.width = 100.0, // 기본 값
    this.badge,
  }); //ㄱ

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // 뱃지 위해 스택을 사용, 뱃지가 범위를 넘어가도 안짤리도록 함

      children: [
        Container(
          width: width,
          height: height, // 설정 안하면 기본값, 설정 하면 변경 가능
          // list에도 사용될 프로필 이미지라 변경 가능하도록 해놨음
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
          ), // 일단 디자인 보기 위해 asset으로 받음. 아마 나중엔 image.network()로 받지 않을까 생각됨
        ),

        if (badge != null)
          Positioned(
            top: -5,
            left: -5, // 좌측 상단에 위치
            child: Container(
              width: width * 0.35,
              height: height * 0.35,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Image.asset(badge!, fit: BoxFit.contain),
              ),
            ),
          ),
      ],
    );
  }
}
