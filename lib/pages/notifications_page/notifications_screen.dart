import 'package:flutter/material.dart';
import 'package:notif_repository/notif_repository.dart' ;
import 'package:twitter_clonex/pages/profile_page/user_profile_page.dart';

class NotificationsPage extends StatelessWidget {
  final String userId;
  const NotificationsPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final notifRepo = FirebaseNotifRepository();
    return Scaffold(
      appBar: AppBar(title: const Text('Bildirimler') , leading: const Text(""),),
      body: StreamBuilder<List<NotificationModel>>(
        stream: notifRepo.getNotifications(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final notifications = snapshot.data!
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          if (notifications.isEmpty) {
            return const Center(child: Text('Henüz bir bildiriminiz yok.'));
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return InkWell(
                onTap: () {
                   Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                                
                               return UserProfilePage(thisUser: notification.fromUser) ;
                               
                },));
                },
                child: ListTile(
                  
                  leading: CircleAvatar(backgroundImage: NetworkImage(notification.fromUser.picture!),),
                  title: Text(notification.notificationType == 'follow'
                      ? '${notification.fromUser.name} sizi takip etti.'
                      : '${notification.fromUser.name} takipten çıktı.'),
                  subtitle: Text(notification.createdAt.toString()),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
