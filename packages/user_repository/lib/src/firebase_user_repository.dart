import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:user_repository/src/entities/entities.dart';
import 'package:user_repository/src/models/my_user.dart';
import 'package:user_repository/src/user_repo.dart';


class FirebaseUserRepository implements UserRepository {
  FirebaseUserRepository({FirebaseAuth? firebaseAuth}) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;
  final userCollection = FirebaseFirestore.instance.collection("user");
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  @override
  
  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseuser){
      final user =firebaseuser;
      return user;
    });
  }
  @override
  Future<String?> getFCMToken(String id) async {
    await _firebaseMessaging.requestPermission();
  final fCMToken = await _firebaseMessaging.getToken();
  print("token: $fCMToken" );
   if (fCMToken != null) {
      // FCM token'ı Firestore'daki kullanıcı dokümanına ekleniyor
      await userCollection.doc(id).update({
        'fcmToken': fCMToken,
      });
    }
   return null;

}
  
  @override
  Future<MyUser> signUpWithEmailPassword(MyUser myUser, String password) async {
    try {
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(email: myUser.email, password: password);

      myUser = myUser.copyWith(id: user.user!.uid);

            // FCM token'ını alıyoruz
      

      await userCollection.doc(myUser.id).set({
        'id': myUser.id,
        'email': myUser.email,
        'name': myUser.name,
        'picture': myUser.picture,
        'follower': myUser.follower,
        'following': myUser.following,
          // FCM token'ı Firestore'a kaydediliyor
      });
          // FCM token alınıyor ve daha sonra güncelleniyor
    
   

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
  
  @override
  Future<String> uploadPicture(String file, String userId)async {
    try {
      File imageFile= File(file);
      Reference firebaseStoreRef = FirebaseStorage.instance.ref().child('$userId/PP/${userId}_lead');
      await firebaseStoreRef.putFile(imageFile);
      String url = await firebaseStoreRef.getDownloadURL();
      await userCollection.doc(userId).update({'picture' : url });
      return url ;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
  
  @override
  Future<List<MyUser>> searchUsers(String query) async{
     final result = await FirebaseFirestore.instance
      .collection('user')
      .where('name', isGreaterThanOrEqualTo: query)
      .where('name', isLessThanOrEqualTo: '$query\uf8ff')
      .get();

  return result.docs.map((doc) => MyUser.fromEntitiy(MyUserEntities.fromDocument(doc.data()))).toList();
  }
  
  @override
  Future<void> followUser(MyUser currentUser, MyUser targetUser)async {
   try {
    // currentUser "following" listesine targetUser'ı ekler
    currentUser.addFollowing(targetUser.id);

    // targetUser "follower" listesine currentUser'ı ekler
    targetUser.addFollower(currentUser.id);

    // Firestore'da currentUser güncellenir
    await FirebaseFirestore.instance
        .collection('user')
        .doc(currentUser.id)
        .update({
      'following': currentUser.following,
    });

    // Firestore'da targetUser güncellenir
    await FirebaseFirestore.instance
        .collection('user')
        .doc(targetUser.id)
        .update({
      'follower': targetUser.follower,
    });
  } catch (e) {
    log("Takip etme hatası: $e");
  }
  
  }
  
  @override
  Future<void> unfollowUser(MyUser currentUser, MyUser targetUser) async{
   try {
    // currentUser "following" listesinden targetUser'ı çıkarır
    currentUser.removeFollowing(targetUser.id);

    // targetUser "follower" listesinden currentUser'ı çıkarır
    targetUser.removeFollower(currentUser.id);

    // Firestore'da currentUser güncellenir
    await FirebaseFirestore.instance
        .collection('user')
        .doc(currentUser.id)
        .update({
      'following': currentUser.following,
    });

    // Firestore'da targetUser güncellenir
    await FirebaseFirestore.instance
        .collection('user')
        .doc(targetUser.id)
        .update({
      'follower': targetUser.follower,
    });
  } catch (e) {
    log("Takipten çıkma hatası: $e");
  }
  }
  @override 
    Future<List<MyUser>> getUsersByIds(List<String> userIds) async {
    try {
      final usersSnapshot = await userCollection.where('id', whereIn: userIds).get();
      return usersSnapshot.docs.map((doc) {
        return MyUser.fromEntitiy(MyUserEntities.fromDocument(doc.data()));
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
  
  @override
  Stream<MyUser> getUserStreamById(String userId) {
         return userCollection.doc(userId).snapshots().map((snapshot) {
    if (snapshot.exists && snapshot.data() != null) {
      final userEntity = MyUserEntities.fromDocument(snapshot.data()!);
      return MyUser.fromEntitiy(userEntity);
    } else {
      throw Exception("Kullanıcı bulunamadı veya veri hatası oluştu");
    }
  });
}
    
  }
  

  
 


  //sign in

  //sign out

  //sign up

  //reset password
