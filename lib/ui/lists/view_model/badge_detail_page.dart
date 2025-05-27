import 'package:bookbug/ui/core/ui/badgedetail_base.dart';
import 'package:bookbug/ui/core/ui/popup_base.dart';
import 'package:flutter/material.dart';
import 'package:bookbug/data/model/badge_model.dart' as model;
import 'package:bookbug/data/services/api_service.dart';

class BadgeDetailPage extends StatefulWidget {
  final int badgeId;
  const BadgeDetailPage({super.key, required this.badgeId});

  @override
  State<BadgeDetailPage> createState() => _BadgeDetailPageState();
}

class _BadgeDetailPageState extends State<BadgeDetailPage> {
  Future<model.BadgeDetail>? _badgeDetailFuture;

  @override
  void initState() {
    super.initState();
    _badgeDetailFuture = ApiService.getBadgeDetail(widget.badgeId);
  }

  Future<void> _setMainBadge() async {
    if (!mounted) return;
    showDialog(
      context: context, 
      builder: (dialogcontext) => PopUpCard(
        title: '대표 뱃지 설정', 
        description: '이 뱃지를 대표 뱃지로 설정할까요?',
        leftButtonText: '취소', 
        rightButtonText: '설정', 
        onLeftPressed: () => Navigator.of(dialogcontext).pop(), 
        onRightPressed: () async {
          Navigator.of(dialogcontext).pop();
          await ApiService.setMainBadge(widget.badgeId);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('대표 뱃지로 설정되었습니다.')),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text('뱃지 상세', style: Theme.of(context).textTheme.titleMedium),
      ),
      body: FutureBuilder<model.BadgeDetail>(
        future: _badgeDetailFuture, 
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('에러: ${snapshot.error}'));
          } else {
            final badge = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: BadgeDetailCard(
                icon: Icons.star, 
                title: badge.name, 
                subtitle: badge.description, 
                onSetAsMain: _setMainBadge,
              ),
            );
          }
        },
      ),
    );
  }
}