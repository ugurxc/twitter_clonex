import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/src/entities/entities.dart';
import 'package:user_repository/src/models/my_user.dart';
import 'package:user_repository/src/user_repo.dart';

class FirebaseUserRepository implements UserRepository {
  FirebaseUserRepository({FirebaseAuth? firebaseAuth}) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;
  final userCollection = FirebaseFirestore.instance.collection("user");

  @override
  
  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseuser){
      final user =firebaseuser;
      return user;
    });
  }


  @override
  Future<MyUser> signUpWithEmailPassword(MyUser myUser, String password) async {
    try {
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(email: myUser.email, password: password);

      myUser = myUser.copyWith(id: user.user!.uid);
      return myUser;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> signInWithEmailPassword(String email, String password) async {
    try {
          await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> logOut() async{
    try {

      _firebaseAuth.signOut();

    } catch (e) {
        log(e.toString());
        rethrow;
    }
  }
  
  @override
  Future<MyUser> getMyUser(String myUserId)async {
    try {
      return userCollection.doc(myUserId).get().then((value) => MyUser.fromEntitiy(MyUserEntities.fromDocument(value.data()!)),);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
  
  @override
  Future<void> setUserData(MyUser user)async {
    try {
      await userCollection.doc(user.id).set(user.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
  


  //sign in

  //sign out

  //sign up

  //reset password
}
