import 'package:flutter/material.dart';
class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final value = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(appBar: AppBar(),
    
    body: Center(child: Text('adsfads $value'),),);
  }
}