import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:message_repository/message_repository.dart';


class FirebaseChatRepository implements MessageRepository{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Firestore'a mesaj gönderme
  @override
  Future<void> sendMessage(ChatMessageModel message, String chatId) async {
    try {
      await firestore.collection('chats/$chatId/messages').add(message.toEntity().toDocument());
    } catch (e) {
      log('Mesaj gönderilemedi: $e');
    }
  }

  // Firestore'dan mesajları alma
  @override
  Stream<List<ChatMessageModel>> getMessages(String chatId) {
    return firestore.collection('chats/$chatId/messages')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) {
          return ChatMessageModel.fromEntity(
            ChatMessageEntity.fromDocument(doc.data())
          );
        }).toList();
      });
  }
}
