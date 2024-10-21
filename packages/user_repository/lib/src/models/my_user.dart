// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:user_repository/src/entities/entities.dart';

class MyUser extends Equatable {


  final String id;
  final String email;
  final String name;
   String? picture;
   List<String>? follower;
   List<String>? following;
   String? fcmToken;

   MyUser({required this.id, required this.email, required this.name,  this.picture , this.follower, this.following , this.fcmToken,});


  static final  empty= MyUser(id: "", email: "", name: "", picture: "" , follower: const [] , following:  const [] , fcmToken: null);


    MyUser copyWith({
    String? id,
    String? email,
    String? name,
    String? picture,
    List<String>? follower,
    List<String>? following,
    String? fcmToken, 
    

  }) {
    return MyUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      picture: picture ?? this.picture,
      follower: follower ?? this.follower,
      following: following?? this.following,
      fcmToken: fcmToken??this.fcmToken
    );
  }

  int get followingCount => following?.length ?? 0;

  int get followerCount => follower?.length ?? 0;

  bool get  isEmpty => this==MyUser.empty;

  bool get  isNotEmpty => this!=MyUser.empty;

  MyUserEntities toEntity(){
    return MyUserEntities(
      id:id,
      email:email,
      name:name,
      picture:picture,
      follower:follower,
      following:following,
      fcmToken: fcmToken, 
      

    );
  }

  static MyUser fromEntitiy(MyUserEntities entity){
      return MyUser(id: entity.id, email: entity.email, name: entity.name, picture: entity.picture,follower:entity.follower,following:entity.following, fcmToken: entity.fcmToken, );
  }

  void addFollower(String userId) {
    follower = (follower ?? [])..add(userId);
  }

  void removeFollower(String userId) {
    follower = (follower ?? [])..remove(userId);
  }

  void addFollowing(String userId) {
    following = (following ?? [])..add(userId);
  }

  void removeFollowing(String userId) {
    following = (following ?? [])..remove(userId);
  }

bool isFollowing(MyUser currentUser, String targetUserId) {
  return currentUser.following?.contains(targetUserId) ?? false;
}

  @override

  List<Object?> get props => [id,email,name,picture,follower , following , fcmToken];



}
