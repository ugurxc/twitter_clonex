import 'models/message.dart';

abstract class MessageRepository {

  Future<void> sendMessage(ChatMessageModel message, String chatId);

  Stream<List<ChatMessageModel>> getMessages(String chatId);

}