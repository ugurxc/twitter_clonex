import 'package:notif_repository/notif_repository.dart';

abstract class NotifRepository {
  Stream<List<NotificationModel>> getNotifications(String userId);
  Future<void> createNotification(NotificationModel notification);
}