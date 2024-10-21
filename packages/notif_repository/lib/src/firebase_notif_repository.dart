import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notif_repository/notif_repository.dart';
import 'package:notif_repository/src/notif_repo.dart';
import 'package:uuid/uuid.dart';

class FirebaseNotifRepository  implements NotifRepository{
  final notificationCollection = FirebaseFirestore.instance.collection("notifications");

  @override
  Future<void> createNotification(NotificationModel notification) async {
    try {
      notification.notificationId = const Uuid().v1();
      notification.createdAt = DateTime.now();
      await notificationCollection
          .doc(notification.notificationId)
          .set(notification.toEntity().toDocument());
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

@override
Stream<List<NotificationModel>> getNotifications(String userId) {
  try {
    return notificationCollection
        .where("targetUserId", isEqualTo: userId)
        .snapshots() // Firestore'dan gerçek zamanlı güncellemeler almak için snapshots() kullanıyoruz
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationModel.fromEntity(NotifEntities.fromDocument(doc.data())))
            .toList());
  } catch (e) {
    print(e.toString());
    rethrow; // Hata fırlatma işlemi
  }
}



final _firebaseMessaging =FirebaseMessaging.instance;
Future<void> initNotifation() async{
  await _firebaseMessaging.requestPermission();
  final fCMToken = await _firebaseMessaging.getToken();
  print("token: $fCMToken" );
}
}