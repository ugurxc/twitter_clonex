/* import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_repository/user_repository.dart';

class PostEntities {
  final String postId;
  final String post;
  final DateTime creadetAt;
  final MyUser myUser; //dsdsd
  final String? postPic;

  const PostEntities({required this.postId, required this.post, required this.creadetAt, required this.myUser , required this.postPic});

  Map<String, Object?> toDocument() {
    return {"postId": postId, "post": post, "creadetAt": creadetAt, "myUser": myUser.toEntity().toDocument() , "postPic":postPic};
  }

  static PostEntities fromDocument(Map<String, dynamic> doc) {
    return PostEntities(
        postId: doc["postId"] as String,
        post: doc["post"] as String,
        creadetAt:(doc["creadetAt"] as  Timestamp).toDate()  ,
        myUser:  MyUser.fromEntitiy(MyUserEntities.fromDocument( doc["myUser"])) ,
        postPic: doc["postPic"] as String?
        );
  }

  @override
  List<Object?> get props => [postId, post, creadetAt, myUser, postPic];

  @override
  String toString() {
    return ''' PostEntities:{

    postId: $postId
    post: $post
    creadetAt: $creadetAt
    myUser: $myUser
    postPic: $postPic

    }''';
  }
} */
// Mesaj Entity
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ChatMessageEntity extends Equatable {
  final String id;
  final String text;
  final String senderId; // Mesajı gönderenin ID'si
  final String receiverId;
  final DateTime createdAt;
  final bool isNotificationSent;
  final bool isSeen; 
  final String? picture;
  final String? idDoc;
  final String? audio; // Mesajın gönderildiği zaman

  const ChatMessageEntity({
    required this.id,
    required this.text,
    required this.senderId,
    required this.createdAt,
    required this.receiverId,
    this.isNotificationSent = false,
    this.isSeen=false,
    required this.picture,
    required this.idDoc,
    required this.audio
    
  });

  // Mesajı Firestore'a uygun bir dökümana çeviriyoruz.
  Map<String, Object?> toDocument() {
    return {
      "id": id,
      "text": text,
      "senderId": senderId,
      "receiverId": receiverId,
      "createdAt": createdAt.toIso8601String(),
      "isNotificationSent": isNotificationSent,
      "isSeen":isSeen, // Tarihi string olarak kaydediyoruz
      "picture":picture,
      "idDoc":idDoc,
      "audio":audio
    };
  }

  // Firestore'dan gelen veriyi bir entity'e çeviriyoruz.
  static ChatMessageEntity fromDocument(Map<String, dynamic> doc) {
    return ChatMessageEntity(
      id: doc["id"] as String,
      text: doc["text"] as String,
      senderId: doc["senderId"] as String,
      receiverId:doc["receiverId"] as String,
      createdAt:DateTime.parse(doc["createdAt"] as String),
       isNotificationSent: doc["isNotificationSent"] as bool? ?? false,
       isSeen:doc["isSeen"] as bool? ?? false,
       picture:doc["picture"] as String?,
       idDoc:doc["idDoc"] as String? ??"",
       audio:doc["audio"] as String?
      
    );
  }

  @override
  List<Object?> get props => [id, text, senderId, receiverId, createdAt, isNotificationSent , isSeen, picture,idDoc , audio];
}