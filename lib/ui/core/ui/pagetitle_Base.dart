import 'package:flutter/material.dart';

class PagetitleBase extends StatelessWidget {
  final String title;
  final double fontsize;
  final Color? color;
  final TextAlign align;
  final EdgeInsetsGeometry padding;

  const PagetitleBase({
    super.key,
    required this.title, // 필수 데이터
    this.fontsize = 20,
    this.color,
    this.align = TextAlign.left, //텍스트 정렬
    this.padding = const EdgeInsets.all(8.0), // 모든 방향 여백 설정
  }); // 여기까지 기본값

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        title,
        textAlign: align,
        style: TextStyle(
          fontSize: fontsize,
          color: color ?? Theme.of(context).colorScheme.onSurface,
          // color 값이 없다면 ??뒤의 값을 받음.
        ),
      ),
    );
  }
}
