import 'package:bookbug/ui/core/ui/listitem_base.dart';
import 'package:bookbug/ui/core/ui/popup_base.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, dynamic>> notifications = List.generate(12, (index) => {
    'title': 'List Item $index',
    'content' : 'Supporting the text for item $index',
    'date' : '${index + 1}시간 전',
    'isRead': index % 3 == 0,
  });

  void _markAllAsRead() {
    setState(() {
      for (var n in notifications) {
        n['isRead'] = true;
      }
    });
  }

  void _deleteAll() {
    showDialog(
      context: context, 
      builder: (_) => PopUpCard(
        title: '알림을 모두 지울까요?', 
        description: '삭제된 알림은 복구할 수 없어요.',
        leftButtonText: '네', 
        rightButtonText: '아니오', 
        onRightPressed: () => Navigator.of(context).pop(),
        onLeftPressed: () {
          setState(() {
            notifications.clear();
          });
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림'),
        actions: [
          IconButton(
            onPressed: _markAllAsRead, 
            icon: const Icon(Icons.visibility_outlined),
            tooltip: '모두 읽기',
          ),
          IconButton(
            onPressed: _deleteAll, 
            icon: const Icon(Icons.delete_outline),
            tooltip: '모두 삭제',
          ),
        ],
      ),
      body: notifications.isEmpty
        ? const Center(child: Text('알림이 없습니다.'),)
        : ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final n = notifications[index];
              final isRead = n['isRead'] as bool;
              return ListItem(
                nickname: '', 
                title: '',
                content: '', 
                trailingText: n['date']!,
                leadingText: null,
                leadingImageUrl: null,
                titleWidget: Text(
                    n['title']!,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                        ),
                  ),
                contentWidget: Text(
                    n['content']!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                onTap: () {
                  setState(() {
                    notifications[index]['isRead'] = true;
                  });
                },
              );
            },
          ),
    );
  }
}