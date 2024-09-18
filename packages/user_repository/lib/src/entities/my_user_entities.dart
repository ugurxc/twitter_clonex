import 'package:equatable/equatable.dart';

class MyUserEntities extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? picture;

  const MyUserEntities({required this.id, required this.email, required this.name, required this.picture});

  Map<String, Object?> toDocument() {
    return {"id": id, "email": email, "name": name, "picture": picture};
  }

  static MyUserEntities fromDocument(Map<String, dynamic> doc) {
    return MyUserEntities(
        id: doc["id"] as String,
        email: doc["email"] as String,
        name: doc["name"] as String,
        picture: doc["picture"] as String?);
  }

  @override
  List<Object?> get props => [id, email, name, picture];

  @override
  String toString() {
    return ''' UserEntity:{

    id: $id
    email: $email
    name: $name
    picture: $picture

    }''';
  }
}
