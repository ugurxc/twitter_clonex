/* import 'package:post_repository/message_repository.dart';
import 'package:user_repository/user_repository.dart';

class Post {
  String postId;
  String post;
  DateTime creadetAt;
  MyUser myUser;
  String? postPic;

   Post({required this.postId, required this.post, required this.creadetAt, required this.myUser ,  this.postPic});


  static final  empty= Post(postId: "", post: "", creadetAt: DateTime.now(), myUser: MyUser.empty , postPic: "");


    Post copyWith({
    String? postId,
    String? post,
    DateTime? creadetAt,
    MyUser? myUser,
    String? postPic
  }) {
    return Post(
      postId: postId ?? this.postId,
      post: post ?? this.post,
      creadetAt: creadetAt ?? this.creadetAt,
      myUser: myUser ?? this.myUser,
      postPic: postPic ?? this.postPic
    );
  }

  bool get  isEmpty => this==Post.empty;

  bool get  isNotEmpty => this!=Post.empty;

  PostEntities toEntity(){
    return PostEntities(
      postId:postId,
      post:post,
      creadetAt:creadetAt,
      myUser:myUser,
      postPic:postPic

    );
  }

  static Post fromEntitiy(PostEntities entity){
      return Post(postId: entity.postId, post: entity.post, creadetAt: entity.creadetAt, myUser: entity.myUser , postPic:entity.postPic);
  }





  @override
  String toString() {
    return ''' Post:{

    postId: $postId
    post: $post
    creadetAt: $creadetAt
    myUser: $myUser
    postPic: $postPic

    }''';
  }



} */
// Mesaj Model


import 'package:message_repository/message_repository.dart';

class ChatMessageModel {
  final String id;
  final String text;
  final String senderId;
  final DateTime createdAt;

  ChatMessageModel({
    required this.id,
    required this.text,
    required this.senderId,
    required this.createdAt,
  });

  // Modeli Entity'ye çeviriyoruz
  ChatMessageEntity toEntity() {
    return ChatMessageEntity(
      id: id,
      text: text,
      senderId: senderId,
      createdAt: createdAt,
    );
  }

  // Entity'den modeli oluşturuyoruz
  static ChatMessageModel fromEntity(ChatMessageEntity entity) {
    return ChatMessageModel(
      id: entity.id,
      text: entity.text,
      senderId: entity.senderId,
      createdAt: entity.createdAt,
    );
  }
}