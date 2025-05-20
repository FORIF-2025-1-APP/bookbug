import 'package:bookbug/ui/core/ui/badgecomponent_base.dart';
import 'package:bookbug/ui/lists/view_model/badge_detail_page.dart';
import 'package:flutter/material.dart';

class BadgeListPage extends StatelessWidget {
  const BadgeListPage ({super.key});

  @override
  Widget build(BuildContext context) {
    final badgeData = List.generate(13, (index) => {
      'icon': Icons.star,
      'label': 'Book',
  });
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('뱃지 (${badgeData.length})'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 24,
          crossAxisSpacing: 24,
          childAspectRatio: 0.8,
          children: badgeData.map((badge) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const BadgeDetailPage(
                      icon: Icons.star, 
                      title: '책 10권에 리뷰 작성 완료!', 
                      subtitle: '관리자 생성',
                    ),
                  ),
                );
              },
              child: BadgeItem(
                icon: badge['icon'] as IconData,
                label: badge['label'] as String,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

