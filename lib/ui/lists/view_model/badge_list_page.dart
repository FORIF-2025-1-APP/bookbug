import 'package:bookbug/data/services/api_service.dart';
import 'package:bookbug/ui/core/ui/badgecomponent_base.dart';
import 'package:bookbug/ui/lists/view_model/badge_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:bookbug/data/model/badge_model.dart' as model;

class BadgeListPage extends StatefulWidget {
  const BadgeListPage ({super.key});

  @override
  State<BadgeListPage> createState() => _BadgeListPageState();
}

class _BadgeListPageState extends State<BadgeListPage> {
  late Future<List<model.BadgeItem>>? _badgeListFuture;
  int badgeCount = 0;

  @override
  void initState() {
    super.initState();
    _badgeListFuture = ApiService.getBadgeList().then((list) {
      setState(() {
        badgeCount = list.length;
      });
      return list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text('뱃지 ($badgeCount)'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<List<model.BadgeItem>>(
        future: _badgeListFuture, 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('에러: ${snapshot.error}'));
          } else {
            final badges = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: GridView.builder(
                itemCount: badges.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ), 
                itemBuilder: (context, index) {
                  final badge = badges[index];
                  return BadgeItem(
                    icon: Icons.star,
                    label: badge.name,
                    onTap:() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BadgeDetailPage(badgeId: badge.id),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

