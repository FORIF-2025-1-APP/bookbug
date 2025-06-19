import 'package:bookbug/ui/core/ui/listitem_base.dart';
import 'package:bookbug/ui/core/ui/popup_base.dart';
import 'package:flutter/material.dart';
import 'package:bookbug/data/services/api_service.dart';
import 'package:bookbug/data/model/notification_model.dart';
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  Future<List<NotificationItem>>? _notificationsFuture;
  int notificationCount = 0;

  @override
  void initState() {
    super.initState();
    _refreshNotifications();
  }

  void _refreshNotifications() {
    _notificationsFuture = ApiService.getNotifications().then((list) {
      setState(() {
        notificationCount = list.length;
      });
      return list;
    });
  }

  Future<void> _handleNotificationTap(int id) async {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (dialogcontext) => PopUpCard(
        title: '알림 확인',
        description: '이 알림을 읽음 처리할까요?',
        leftButtonText: '네',
        rightButtonText: '아니오',
        onRightPressed: () => Navigator.of(dialogcontext).pop(),
        onLeftPressed: () async {
          Navigator.of(dialogcontext).pop();
          await ApiService.markNotificationRead(id);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('읽음 처리 완료')),
          );
          setState(() {
            _notificationsFuture = ApiService.getNotifications();
          });
        },
      ),
    );
  }

  Future<void> _markAllRead() async {
    showDialog(
      context: context, 
      builder: (context) => PopUpCard(
        title: '모두 읽기', 
        description: '모든 알림을 읽음 처리할까요?',
        leftButtonText: '네', 
        rightButtonText: '아니오',
        onLeftPressed: () async {
          Navigator.of(context).pop();
          await ApiService.markAllNotificationsRead();
          if (mounted) _refreshNotifications();
        }, 
        onRightPressed: () => Navigator.of(context).pop(),
      ));
  }

  Future<void> _deleteAll() async {
    showDialog(
      context: context, 
      builder: (context) => PopUpCard(
        title: '알림을 모두 지울까요?', 
        description: '삭제된 알림은 복구할 수 없어요.',
        leftButtonText: '네', 
        rightButtonText: '아니오', 
        onLeftPressed: () async {
          Navigator.of(context).pop();
          await ApiService.deleteAllNotifications();
          if (mounted) _refreshNotifications();
        }, 
        onRightPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('알림 ($notificationCount)'),
        actions: [
          IconButton(
            onPressed: _markAllRead, 
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
      body: FutureBuilder<List<NotificationItem>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child:CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('에러: ${snapshot.error}'));
          } else {
            final notis = snapshot.data!;
            return ListView.builder(
              itemCount: notis.length,
              itemBuilder: (context, index) {
                final n = notis[index];
                return ListItem(
                  nickname: n.title, 
                  title: n.body, 
                  content: '', 
                  trailingText: '',
                  leadingText: 'N',
                  onTap: () => _handleNotificationTap(n.id),
                  customTrailing: Text(
                    n.createdAt.substring(0, 10),
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}