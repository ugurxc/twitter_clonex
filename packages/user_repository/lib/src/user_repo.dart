

import 'package:firebase_auth/firebase_auth.dart';

import '../user_repository.dart';

abstract class UserRepository {

Stream<User?> get user;

Future<void> signInWithEmailPassword(String email , String password);

Future<void> logOut();

Future<MyUser> signUpWithEmailPassword(MyUser myUser , String password);

//setUserData
Future<void> setUserData(MyUser user);

//getMyUser
Future<MyUser> getMyUser(String myUserId);

Future<String> uploadPicture(String file ,String userId);

Future<List<MyUser>> searchUsers(String query);


Future<void> followUser(MyUser currentUser, MyUser targetUser);

Future<void> unfollowUser(MyUser currentUser, MyUser targetUser);

Future<List<MyUser>> getUsersByIds(List<String> userIds);

Future<String?> getFCMToken(String id);

}
