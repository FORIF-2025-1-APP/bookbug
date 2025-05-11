import 'package:flutter/material.dart';

class ProfileimageBase extends StatelessWidget {
  final String image;
  final String? badge;
  final double width;
  final double height;

  const ProfileimageBase({
    super.key,
    required this.image,
    this.height = 100.0,
    this.width = 100.0,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
          ),
        ),

        if (badge != null)
          Positioned(
            top: -5,
            left: -5,
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
