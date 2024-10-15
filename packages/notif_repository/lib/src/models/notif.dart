import 'package:notif_repository/notif_repository.dart';
import 'package:user_repository/user_repository.dart';

class NotificationModel {
  String notificationId;
  String notificationType;
  DateTime createdAt;
  MyUser fromUser;
  String targetUserId;

  NotificationModel({
    required this.notificationId,
    required this.notificationType,
    required this.createdAt,
    required this.fromUser,
    required this.targetUserId,
  });

  static final empty = NotificationModel(
    notificationId: "",
    notificationType: "",
    createdAt: DateTime.now(),
    fromUser: MyUser.empty,
    targetUserId: "",
  );

  NotifEntities toEntity() {
    return NotifEntities(
      notificationId: notificationId,
      notificationType: notificationType,
      createdAt: createdAt,
      fromUser: fromUser,
      targetUserId: targetUserId,
    );
  }

  static NotificationModel fromEntity(NotifEntities entity) {
    return NotificationModel(
      notificationId: entity.notificationId,
      notificationType: entity.notificationType,
      createdAt: entity.createdAt,
      fromUser: entity.fromUser,
      targetUserId: entity.targetUserId,
    );
  }
}
