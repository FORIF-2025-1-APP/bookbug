import 'package:flutter/material.dart';

class BadgeDetailCard extends StatelessWidget {
  final IconData icon; // 중앙 아이콘
  final String title; // 뱃지 이름
  final String subtitle; // 뱃지 설명
  final VoidCallback onSetAsMain; // 대표 뱃지로 설정

  const BadgeDetailCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onSetAsMain,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 아이콘 포함 박스
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
          padding: const EdgeInsets.symmetric(vertical: 48),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer, // 전체 배경색
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.surfaceContainerHighest, // 아이콘 배경색
              ),
              child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 28),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // 제목
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        // 서브 텍스트
        Text( 
          subtitle,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 24),
        // 대표 뱃지 설정 버튼
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: onSetAsMain,
            child: const Text('대표 뱃지로 설정'),
          ),
        ),
      ],
    );
  }
}