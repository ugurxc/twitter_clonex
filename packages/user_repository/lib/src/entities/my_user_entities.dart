import 'package:equatable/equatable.dart';

class MyUserEntities extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? picture;
  final List<String>? follower;
  final List<String>? following;
  final String? fcmToken;
  final bool isOnline;
  const MyUserEntities( {required this.id, required this.email, required this.name, required this.picture ,required this.follower, required this.following ,required this.fcmToken , this.isOnline = false,});

  Map<String, Object?> toDocument() {
    return {"id": id, "email": email, "name": name, "picture": picture ,"follower" :follower , "following": following , "fcmToken":fcmToken, "isOnline": isOnline, };
  }

  static MyUserEntities fromDocument(Map<String, dynamic> doc) {
    return MyUserEntities(
      
        id: doc["id"] as String,
        email: doc["email"] as String,
        name: doc["name"] as String,
        picture: doc["picture"] as String?,
        follower: (doc["follower"] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
        following: (doc["following"] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],  
        fcmToken:doc["fcmToken"] as String? ,
        isOnline: doc["isOnline"] as bool? ?? false,
         
        );
        
  }

  @override
  List<Object?> get props => [id, email, name, picture, follower, following, fcmToken , isOnline];

  @override
  String toString() {
    return ''' UserEntity:{

    id: $id
    email: $email
    name: $name
    picture: $picture
    follower: $follower
    following:$following
    fcmToken:$fcmToken
    isOnline:$isOnline

    }''';
  }
}
