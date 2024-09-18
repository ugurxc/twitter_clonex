

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
}