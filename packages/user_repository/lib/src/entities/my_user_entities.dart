import 'package:equatable/equatable.dart';

class MyUserEntities extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? picture;
  final List<String>? follower;
  final List<String>? following;
  const MyUserEntities({required this.id, required this.email, required this.name, required this.picture ,required this.follower, required this.following});

  Map<String, Object?> toDocument() {
    return {"id": id, "email": email, "name": name, "picture": picture ,"follower" :follower , "following": following };
  }

  static MyUserEntities fromDocument(Map<String, dynamic> doc) {
    return MyUserEntities(
        id: doc["id"] as String,
        email: doc["email"] as String,
        name: doc["name"] as String,
        picture: doc["picture"] as String?,
        follower: (doc["follower"] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
        following: (doc["following"] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],    
        );
        
  }

  @override
  List<Object?> get props => [id, email, name, picture, follower, following];

  @override
  String toString() {
    return ''' UserEntity:{

    id: $id
    email: $email
    name: $name
    picture: $picture
    follower: $follower
    following:$following

    }''';
  }
}
