import 'package:flutter/material.dart';

class MiniProfile extends StatelessWidget {
  final String profilPic;
  final String email;
  final String name;
  final int followers;
  const MiniProfile({super.key, required this.profilPic, required this.email, required this.name, required this.followers});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      child: Column(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(profilPic),),
          Text(email),
          Text(name),
          Text("$followers followers")
        ],
      ),
    );
  }
}
