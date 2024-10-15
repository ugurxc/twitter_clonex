import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_repository/user_repository.dart';




class NotifEntities {
  final String notificationId;
  final String notificationType; // Takip, takipten çıkma, vb.
  final DateTime createdAt;
  final MyUser fromUser; // Bildirimi gönderen kullanıcı
  final String targetUserId; // Bildirim kime gönderilecek

  NotifEntities({
    required this.notificationId,
    required this.notificationType,
    required this.createdAt,
    required this.fromUser,
    required this.targetUserId,
  });

  Map<String, Object?> toDocument() {
    return {
      "notificationId": notificationId,
      "notificationType": notificationType,
      "createdAt": createdAt,
      "fromUser": fromUser.toEntity().toDocument(),
      "targetUserId": targetUserId,
    };
  }

  static NotifEntities fromDocument(Map<String, dynamic> doc) {
    return NotifEntities(
      notificationId: doc["notificationId"] as String,
      notificationType: doc["notificationType"] as String,
      createdAt: (doc["createdAt"] as Timestamp).toDate(),
      fromUser: MyUser.fromEntitiy(MyUserEntities.fromDocument(doc["fromUser"])),
      targetUserId: doc["targetUserId"] as String,
    );
  }
}
