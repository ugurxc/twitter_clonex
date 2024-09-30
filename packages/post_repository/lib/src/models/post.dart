import 'package:post_repository/post_repository.dart';
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



}