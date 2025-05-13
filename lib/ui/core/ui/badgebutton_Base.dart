import 'package:flutter/material.dart';

class BadgebuttonBase extends StatelessWidget {
  final String badge;
  final String badgename;

  const BadgebuttonBase({
    super.key,
    required this.badge,
    required this.badgename,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 180, // 뱃지 하나가 차지하는 크기
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFEAEAE0),
            ), // 바깥 회색 원 이 색도 논의해야함.
            child: Center(
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: ClipOval(child: Image.asset(badge, fit: BoxFit.cover)),
              ), // 안쪽 뱃지 이미지
              // 일단 디자인 보기 위해 asset으로 받음. 아마 나중엔 image.network()로 받지 않을까 생각됨
            ),
          ),
          SizedBox(height: 18),
          Text(
            badgename,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color:
                  Theme.of(
                    context,
                  ).colorScheme.onSurface, // 텍스트 컬러 임의 지정함 논의 필요
            ),
          ),
        ],
      ),
    );
  }
}
