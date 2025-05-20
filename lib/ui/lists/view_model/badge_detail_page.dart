import 'package:bookbug/ui/core/ui/badgedetail_base.dart';
import 'package:bookbug/ui/core/ui/popup_base.dart';
import 'package:flutter/material.dart';

class BadgeDetailPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const BadgeDetailPage({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BadgeDetailCard(
                icon: icon,
                title: title,
                subtitle: subtitle,
                onSetAsMain: () {
                  showDialog(
                    context: context,
                    builder: (_) => PopUpCard(
                      title: '대표 뱃지로 설정되었습니다.',
                      leftButtonText: '닫기',
                      rightButtonText: '확인',
                      onLeftPressed: () => Navigator.pop(context),
                      onRightPressed: () => Navigator.pop(context),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => PopUpCard(
                        title: '대표 뱃지로 설정되었습니다.',
                        leftButtonText: '닫기',
                        rightButtonText: '확인',
                        onLeftPressed: () => Navigator.pop(context),
                        onRightPressed: () => Navigator.pop(context),
                      ),
                    );
                  },
                  child: const Text('대표 뱃지로 설정'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
