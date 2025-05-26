import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final String nickname; // 닉네임
  final String title; // 댓글 제목
  final String content; // 댓글 내용
  final String? leadingText; // 이니셜 (프로필 사진 없는 경우)
  final String? leadingImageUrl; // 프로필 이미지 url
  final String trailingText; // 날짜/숫자
  final VoidCallback? onTap;
  
  final Widget? customTrailing;
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
    this.customTrailing,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: leadingImageUrl == null
                      ? colorScheme.primaryContainer
                      : null,
                  backgroundImage: leadingImageUrl != null
                      ? NetworkImage(leadingImageUrl!)
                      : null,
                  child: leadingImageUrl == null && leadingText != null
                      ? Text(
                          leadingText!,
                          style: textTheme.labelLarge?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nickname,
                            style: textTheme.labelLarge?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                          if (customTrailing != null)
                            customTrailing!
                          else 
                            Text(
                              trailingText,
                              style: textTheme.labelMedium?.copyWith(
                                color: colorScheme.outline,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      titleWidget ??
                           Text(
                                  title,
                                  style: textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                      const SizedBox(height: 2),
                      contentWidget ??
                                Text(
                                  content,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.outline,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
