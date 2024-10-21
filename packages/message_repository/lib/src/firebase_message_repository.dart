import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:message_repository/message_repository.dart';


class FirebaseChatRepository implements MessageRepository{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Firestore'a mesaj gönderme
  @override
  Future<void> sendMessage(ChatMessageModel message, String senderUid , String receiverUid) async {

    try {

       

      await firestore
      .collection("user")
      .doc(senderUid)
      .collection("messages")
      
      .add(message.toEntity().toDocument());
      /*     try {
      await firestore.collection('chats//messages').add(message.toEntity().toDocument());
    } catch (e) {
      log('Mesaj gönderilemedi: $e');
    } */

      await firestore
      .collection("user")
      .doc(receiverUid)
      .collection("messages")
      .add(message.toEntity().toDocument());

   // await senderMessagesRef.add(message.toEntity().toDocument());


    } catch (e) {
      log(e.toString());
    }

  }
 
  // Firestore'dan mesajları alma
  @override
  Stream<List<ChatMessageModel>> getMessages(String senderUid , String receiverUid) {
  /*   return firestore.collection('user/$senderUid/messages')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) {
          return ChatMessageModel.fromEntity(
            ChatMessageEntity.fromDocument(doc.data())
          );
        }).toList(); 
      }); */

        /*
         return firestore
        .collection('user')
        .doc(senderUid)
        .collection('messages')
        .where('senderId', isEqualTo: senderUid)
        .where('receiverId', isEqualTo: receiverUid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ChatMessageModel.fromEntity(ChatMessageEntity.fromDocument(doc.data()));
      }).toList();

      }); 
*/
 return firestore
  .collection('user')
  .doc(senderUid)
  .collection('messages')
  .orderBy('createdAt', descending: true)
  .snapshots()
  .map((snapshot) {
    return snapshot.docs
        .map((doc) {
          final data = doc.data();
          final senderId = data['senderId'];
          final receiverId = data['receiverId'];

          // Sadece senderUid ve receiverUid ile eşleşen mesajları filtrele
          if ((senderId == senderUid && receiverId == receiverUid) ||
              (senderId == receiverUid && receiverId == senderUid)) {
            return ChatMessageModel.fromEntity(ChatMessageEntity.fromDocument(data));
          }
          return null; // Uyuşmayanları null döndürüyoruz
        })
        .where((message) => message != null) // Null olanları filtreliyoruz
        .cast<ChatMessageModel>() // Tür dönüşümü yaparak listeyi ChatMessageModel türüne çeviriyoruz
        .toList();
  }); 
  }
}
