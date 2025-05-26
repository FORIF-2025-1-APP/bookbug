import 'package:flutter/material.dart';

class StarRatingBase extends StatelessWidget {
  final double rating;
  final ValueChanged<double> onRatingChanged;
  final int starCount;

  const StarRatingBase({
    super.key,
    required this.rating,
    required this.onRatingChanged,
    this.starCount = 5,
  });

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    double current = index + 1;

    if (rating >= current) {
      icon = const Icon(Icons.star, color: Colors.amber);
    } else if (rating >= current - 0.5) {
      icon = const Icon(Icons.star_half, color: Colors.amber);
    } else {
      icon = const Icon(Icons.star_border, color: Colors.amber);
    }

    return GestureDetector(
      onTap: () {
        onRatingChanged(current.toDouble());
      },
      onHorizontalDragUpdate: (details) {
        RenderBox box = context.findRenderObject() as RenderBox;
        final localPosition = box.globalToLocal(details.globalPosition);
        final percent = localPosition.dx / box.size.width;
        final newRating = (percent * starCount).clamp(0, starCount).toDouble();
        onRatingChanged((newRating * 2).round() / 2); // 0.5 단위로 반올림
      },
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        starCount,
        (index) => buildStar(context, index),
      ),
    );
  }
}