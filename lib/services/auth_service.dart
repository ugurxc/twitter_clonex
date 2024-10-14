/* import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {

  final firebaseAuth = FirebaseAuth.instance;

  Future<User?> signInWithGoogle() async{
    
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    final gAuth =await gUser!.authentication;

    final credential =GoogleAuthProvider.credential(accessToken: gAuth.accessToken, idToken: gAuth.idToken);

    final UserCredential userCredential= await firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
  }
} */
/* import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:twitter_clonex/mobile_layout.dart';

import 'package:twitter_clonex/pages/home_page/home_screen.dart';

class AuthService {
  final userCollection =FirebaseFirestore.instance.collection("users");
  final firebaseAuth = FirebaseAuth.instance;

  Future<void> signUp(BuildContext context,{required String name ,required String email ,required String password}) async{
    final navigator= Navigator.of(context);
      try{
             final UserCredential userCredential=await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
     if(userCredential.user!=null){
        _registerUser(email: email,name: name , password: password);
          navigator.push(MaterialPageRoute(builder: (context) => const HomeScreen(),));
     }
      }on FirebaseAuthException catch(e) {
        Fluttertoast.showToast(msg: e.message!,
                toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.blue,
        fontSize: 16.0);
      }
      

  }

  Future<void> signIn(BuildContext context,{required String email ,required String password}) async{
    final navigator= Navigator.of(context);
      try{
              final UserCredential userCredential=   await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user!=null) {
        navigator.push(
        MaterialPageRoute(
          builder: (context) => MobileLayout(user: userCredential.user!),  // Kullanıcıyı buraya gönderiyoruz
        ),
      );
        
      }
      else{log("problem");}
      } catch(e){
        log(e.toString());
      }

      
  }

  Future<void> _registerUser({required String name , required String email ,required String password})async {
      await userCollection.doc().set({
        "email":email,
        "name":name,
        "password":password
      });
  }



  Future<User?> signInWithGoogle() async{

    
      final GoogleSignInAccount? gUser =  await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuth =await gUser!.authentication;

    final credential =GoogleAuthProvider.credential(accessToken: gAuth.accessToken, idToken: gAuth.idToken);

    final UserCredential userCredential= await firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    
      
      
    }
    

  
} */

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/* Future<UserCredential> signInWithGoogle() async{

    
      final GoogleSignInAccount? gUser =  await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? gAuth =await gUser?.authentication;

    final credential =GoogleAuthProvider.credential(accessToken: gAuth?.accessToken, idToken: gAuth?.idToken);

    
      return await FirebaseAuth.instance.signInWithCredential(credential);
    
      
      
    } */
    






class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Google ile oturum açma
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      // Firebase ile oturum açma
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      log("Hata: ${e.toString()}");
      // Hata mesajını kullanıcıya gösterin
      // Örneğin, bir hata mesajı gösteren bir iletişim kutusu kullanın
    }
    return null;
  }
}
