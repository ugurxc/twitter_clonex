import 'package:flutter/material.dart';
import 'package:twitter_clonex/services/auth_service.dart';

class SigninPage extends StatelessWidget {
   SigninPage({super.key});
  
  final _tEmail =TextEditingController();
  final _tPassword =TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kayıt ol"),),
      body:  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          
          children: [
            const Spacer(flex: 5,),
            
            TextField(
              controller: _tEmail,
              decoration: const InputDecoration( hintText: "email" ,border: OutlineInputBorder()),),
            const Spacer(flex: 2,),
            
             TextField(
              controller: _tPassword,
              decoration: const InputDecoration(  hintText: "parola" ,border: OutlineInputBorder()),),
            const Spacer(flex: 20,),
            ElevatedButton(onPressed: () {
              AuthService().signIn( context, email: _tEmail.text, password: _tPassword.text);
            }, child: const Text("giriş yap"))
          ],

        ),
      ),
    );
  }
}