import 'models/message.dart';

abstract class MessageRepository {

  Future<void> sendMessage(ChatMessageModel message, String senderUid , String receiverUid);

  Stream<List<ChatMessageModel>> getMessages(String senderUid ,String receiverUid);

}