import 'package:flutter/material.dart';
import 'package:notif_repository/notif_repository.dart' ;

class NotificationsPage extends StatelessWidget {
  final String userId;
  const NotificationsPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final notifRepo = FirebaseNotifRepository();
    return Scaffold(
      appBar: AppBar(title: const Text('Bildirimler')),
      body: StreamBuilder<List<NotificationModel>>(
        stream: notifRepo.getNotifications(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final notifications = snapshot.data!;

          if (notifications.isEmpty) {
            return const Center(child: Text('Henüz bir bildiriminiz yok.'));
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return ListTile(
                
                leading: CircleAvatar(backgroundImage: NetworkImage(notification.fromUser.picture!),),
                title: Text(notification.notificationType == 'follow'
                    ? '${notification.fromUser.name} sizi takip etti.'
                    : '${notification.fromUser.name} takipten çıktı.'),
                subtitle: Text(notification.createdAt.toString()),
              );
            },
          );
        },
      ),
    );
  }
}
