import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:twitter_clonex/blocs/create_post_bloc/create_post_bloc.dart';
import 'package:twitter_clonex/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:user_repository/user_repository.dart';

class CreateTwitPage extends StatefulWidget {
  final MyUser myUser;
  const CreateTwitPage(this.myUser, {super.key});

  @override
  State<CreateTwitPage> createState() => _CreateTwitPageState();
}

class _CreateTwitPageState extends State<CreateTwitPage> {
  late Post post;
  final TextEditingController _textController = TextEditingController();
  @override
  void initState() {
    post = Post.empty;
    post.myUser = widget.myUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreatePostBloc, CreatePostState>(
      listener: (context, state) {
        if(state is CreatePostSuccess){
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close)),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                  onPressed: () {
                    if (_textController.text.isNotEmpty) {
                      setState(() {
                        post.post = _textController.text;
                      });
                      context.read<CreatePostBloc>().add(CreatePost(post));
                      log(post.toString());
                    }
                  },
                  child: const Text("Gönderi")),
            )
          ],
        ),
        body: BlocBuilder<MyUserBloc, MyUserState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(state.user!.picture!),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          minLines: 1,
                          maxLines: 10,
                          keyboardType: TextInputType.multiline,
                          maxLength: 200,
                          decoration: const InputDecoration(
                            hintText: "Neler oluyor?", hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none, // Varsayılan çizgiyi kaldır
                            enabledBorder: InputBorder.none, // Etkin olmayan durumdaki çizgiyi kaldır
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
