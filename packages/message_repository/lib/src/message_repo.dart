

import 'models/message.dart';

abstract class MessageRepository {

  Future<void> sendMessage(ChatMessageModel message, String senderUid , String receiverUid);

  Stream<List<ChatMessageModel>> getMessages(String senderUid ,String receiverUid);

  Future<List<ChatMessageModel>> getMessagesOnce(String senderId, String receiverId);

  Future<void> markMessageAsSeen(String messageId, String receiverId);

  Future<void> deleteMessageForEveryone(String messageId, String senderUid, String receiverUid);

  Future<void> deleteMessageForSender(String messageId, String senderUid, String receiverUid);

 

}