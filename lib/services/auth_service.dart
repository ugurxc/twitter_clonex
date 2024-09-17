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
import 'dart:developer';

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
        navigator.push(MaterialPageRoute(builder: (context) => const MobileLayout(),));
        
      }
      else{log("ayıp yav");}
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
    

  
}