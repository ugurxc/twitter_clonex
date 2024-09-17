import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:twitter_clonex/pages/auth_pages/signin_page.dart';


void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Material App',
      home: SigninPage()
    );
  }
}