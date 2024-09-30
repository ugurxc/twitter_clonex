import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_repository/user_repository.dart';

class PostEntities {
  final String postId;
  final String post;
  final DateTime creadetAt;
  final MyUser myUser;
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
}