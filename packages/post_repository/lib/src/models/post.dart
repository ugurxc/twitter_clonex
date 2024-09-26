import 'package:post_repository/post_repository.dart';
import 'package:user_repository/user_repository.dart';

class Post {
  String postId;
  String post;
  DateTime creadetAt;
  MyUser myUser;

   Post({required this.postId, required this.post, required this.creadetAt, required this.myUser});


  static final  empty= Post(postId: "", post: "", creadetAt: DateTime.now(), myUser: MyUser.empty);


    Post copyWith({
    String? postId,
    String? post,
    DateTime? creadetAt,
    MyUser? myUser,
  }) {
    return Post(
      postId: postId ?? this.postId,
      post: post ?? this.post,
      creadetAt: creadetAt ?? this.creadetAt,
      myUser: myUser ?? this.myUser,
    );
  }

  bool get  isEmpty => this==Post.empty;

  bool get  isNotEmpty => this!=Post.empty;

  PostEntities toEntity(){
    return PostEntities(
      postId:postId,
      post:post,
      creadetAt:creadetAt,
      myUser:myUser

    );
  }

  static Post fromEntitiy(PostEntities entity){
      return Post(postId: entity.postId, post: entity.post, creadetAt: entity.creadetAt, myUser: entity.myUser);
  }





  @override
  String toString() {
    return ''' Post:{

    postId: $postId
    post: $post
    creadetAt: $creadetAt
    myUser: $myUser

    }''';
  }



}