import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:message_repository/message_repository.dart';


class FirebaseChatRepository implements MessageRepository{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Firestore'a mesaj gönderme
  @override
  Future<void>sendMessage(ChatMessageModel message, String senderUid , String receiverUid) async {

    try {

       
            final DocumentReference senderDoc= await firestore
      .collection("user")
      .doc(senderUid)
      .collection("messages")
      
      .doc(receiverUid)
      .collection("chat-$receiverUid")
      
      
      .add(message.toEntity().toDocument());
    final messageId = senderDoc.id;
     await senderDoc.update({"idDoc":messageId});
    
      /*     try {
      await firestore.collection('chats//messages').add(message.toEntity().toDocument());
    } catch (e) {
      log('Mesaj gönderilemedi: $e');
    } */

       await firestore
        .collection("user")
        .doc(receiverUid)
        .collection("messages")
        .doc(senderUid)
        .collection("chat-$senderUid")
        .doc(messageId) // Aynı ID'yi kullanıyoruz
        .set(message.toEntity().toDocument()); // set metodu kullanarak kaydediyoruz
        
    await firestore
        .collection("user")
        .doc(receiverUid)
        .collection("messages")
        .doc(senderUid)
        .collection("chat-$senderUid")
        .doc(messageId)
        .update({"idDoc": messageId}); // ID'yi kaydediyoruz


















/*       final DocumentReference senderDoc= await firestore
      .collection("user")
      .doc(senderUid)
      .collection("messages")
      
      .doc(receiverUid)
      .collection("chat-$receiverUid")
      
      
      .add(message.toEntity().toDocument());
    
     await senderDoc.update({"idDoc":senderDoc.id});
    
      /*     try {
      await firestore.collection('chats//messages').add(message.toEntity().toDocument());
    } catch (e) {
      log('Mesaj gönderilemedi: $e');
    } */

      final DocumentReference receiverDoc=  await firestore
      .collection("user")
      .doc(receiverUid)
      .collection("messages")
      .doc(senderUid)
      .collection("chat-$senderUid")

      .add(message.toEntity().toDocument());

      await receiverDoc.update({"idDoc":receiverDoc.id}); */

       
      

    
   // await senderMessagesRef.add(message.toEntity().toDocument());

    
    } catch (e) {
      log(e.toString());
      rethrow;
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
  .doc(receiverUid)
  .collection("chat-$receiverUid")
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
@override

Future<List<ChatMessageModel>> getMessagesOnce(String senderId, String receiverId) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('user')
      .doc(receiverId)
      .collection('messages')
      .get();

  return snapshot.docs.map((doc) => ChatMessageModel.fromEntity(ChatMessageEntity.fromDocument(doc.data()))).toList();
}

@override 
Future<void> markMessageAsSeen(String messageId, String receiverId) async {
  // Firestore'da mesajın isSeen alanını true olarak güncelleriz
  firestore
      .collection('user')
      .doc(receiverId)
      .collection('messages')
      .doc(messageId)
      .update({
        
        'isSeen': true,
      });
}

/* void updateMessageIsSeen(ChatMessageModel message) async{

  if(message.idDoc !=null){
      await Future.delayed(const Duration(milliseconds: 10000));
      FirebaseFirestore.instance
      .collection('user')
      .doc(message.senderId)
      .collection('messages')
      .doc(message.receiverId)
      .collection("chat-${message.receiverId}")
      .doc(message.idDoc)
      .update({"isSeen":true});
  }
  

      
      
} */
void updateMessageIsSeen(ChatMessageModel message) async {
  int retryCount = 0;
  while (message.idDoc == null && retryCount < 5) {
    await Future.delayed(const Duration(milliseconds: 100));
    retryCount++;
  }

  if (message.idDoc != null&& message.idDoc!.isNotEmpty) {
    FirebaseFirestore.instance
      .collection('user')
      .doc(message.senderId)
      .collection('messages')
      .doc(message.receiverId)
      .collection("chat-${message.receiverId}")
      .doc(message.idDoc)
      .update({"isSeen": true}).catchError((error) {
        print("Güncelleme hatası: $error");
      });
  } else {
    // Eğer idDoc hala null ise hata vermeyelim, sadece bilgi mesajı gösterelim
    print("Güncelleme yapılamadı: idDoc hala null.");
  }
}

  @override
  Future<void> deleteMessageForEveryone(String messageId, String senderUid, String receiverUid) async{
      try {
    // Gönderen tarafındaki mesaj koleksiyonundan mesajı sil
    await firestore
        .collection("user")
        .doc(senderUid)
        .collection("messages")
        .doc(receiverUid)
        .collection("chat-$receiverUid")
        .doc(messageId)
        .delete();

    // Alıcı tarafındaki mesaj koleksiyonundan mesajı sil
    await firestore
        .collection("user")
        .doc(receiverUid)
        .collection("messages")
        .doc(senderUid)
        .collection("chat-$senderUid")
        .doc(messageId)
        .delete();
    
    log("Mesaj herkesten başarıyla silindi.");
  } catch (e) {
    log("Mesajı herkesten silerken hata oluştu: $e");
    rethrow;
  }
  }

  @override
  Future<void> deleteMessageForSender(String messageId, String senderUid, String receiverUid)async {

     try {
    // Gönderen tarafındaki mesaj koleksiyonundan mesajı sil
    await firestore
        .collection("user")
        .doc(senderUid)
        .collection("messages")
        .doc(receiverUid)
        .collection("chat-$receiverUid")
        .doc(messageId)
        .delete();

    log("Mesaj sadece senden başarıyla silindi.");
  } catch (e) {
    log("Mesajı sadece senden silerken hata oluştu: $e");
    rethrow;
  }


  }

  Future<void> updateMessage(ChatMessageModel message, String newText) async {


  if (message.idDoc != null&& message.idDoc!.isNotEmpty) {
    FirebaseFirestore.instance
      .collection('user')
      .doc(message.senderId)
      .collection('messages')
      .doc(message.receiverId)
      .collection("chat-${message.receiverId}")
      .doc(message.idDoc)
      .update({"text": newText}).catchError((error) {
        print("Güncelleme hatası: $error");
      });

      FirebaseFirestore.instance
      .collection('user')
      .doc(message.receiverId)
      .collection('messages')
      .doc(message.senderId)
      .collection("chat-${message.senderId}")
      .doc(message.idDoc)
      .update({"text": newText}).catchError((error) {
        print("Güncelleme hatası: $error");
      });
  } else {
    // Eğer idDoc hala null ise hata vermeyelim, sadece bilgi mesajı gösterelim
    print("Güncelleme yapılamadı: idDoc hala null.");
  }
}

}


