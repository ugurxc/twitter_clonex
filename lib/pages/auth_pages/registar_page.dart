import 'package:flutter/material.dart';
import 'package:twitter_clonex/services/auth_service.dart';

class RegistarPage extends StatefulWidget {
  const RegistarPage({super.key});

  @override
  State<RegistarPage> createState() => _RegistarPageState();
}
  final _tName =TextEditingController();
  final _tEmail =TextEditingController();
  final _tPassword =TextEditingController();
class _RegistarPageState extends State<RegistarPage> {

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
              controller: _tName,
              decoration: const InputDecoration( hintText: "kullanıcı adı" ,border: OutlineInputBorder()),),
          
            const Spacer(flex: 2,),
            
             TextField(
              controller: _tPassword,
              decoration: const InputDecoration(  hintText: "parola" ,border: OutlineInputBorder()),),
            const Spacer(flex: 20,),
            ElevatedButton(onPressed: () {
              AuthService().signUp(context,name: _tName.text, email: _tEmail.text, password: _tPassword.text);
            }, child: const Text("Kayıt ol"))
          ],

        ),
      ),
    );
  }
}