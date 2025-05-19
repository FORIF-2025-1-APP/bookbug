import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final String nickname; // 닉네임
  final String title; // 댓글 제목
  final String content; // 댓글 내용
  final String? leadingText; // 이니셜 (프로필 사진 없는 경우)
  final String? leadingImageUrl; // 프로필 이미지 url
  final String trailingText; // 날짜/숫자
  final VoidCallback? onTap; 

  final Widget? titleWidget;
  final Widget? contentWidget;

  const ListItem({
    super.key,
    required this.nickname,
    required this.title,
    required this.content,
    this.leadingText,
    this.leadingImageUrl,
    required this.trailingText,
    this.onTap,
    this.titleWidget,
    this.contentWidget,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 프로필 (이미지 또는 이니셜)
            if (leadingText != null || leadingImageUrl != null)
              CircleAvatar(
                radius: 20,
                backgroundColor: leadingImageUrl == null 
                  ? Theme.of(context).colorScheme.primaryContainer 
                  : null,
                backgroundImage: leadingImageUrl != null
                  ? NetworkImage(leadingImageUrl!)
                  : null,
              child: leadingImageUrl == null && leadingText != null
                ? Text(
                  leadingText!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  )
                : null,
            ),
            if (leadingText != null || leadingImageUrl != null)
              const SizedBox(width: 12),
            
            // 텍스트 영역 (닉네임, 제목, 댓글 내용)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if(nickname.isNotEmpty)
                        Text(
                          nickname,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                        ),
                  Row(
                    children: [
                      Text(
                        trailingText,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(width: 4),
                      if (trailingText.isNotEmpty) ...[
                        const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
                      ]
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 2),
            if (titleWidget != null)
              titleWidget!
            else
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            if ((contentWidget != null) || content.isNotEmpty) ...[
              const SizedBox(height: 2),
              contentWidget ??
                Text(
                  content,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}