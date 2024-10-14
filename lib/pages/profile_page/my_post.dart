import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clonex/blocs/bloc/post_bloc.dart';
import 'package:twitter_clonex/components/constant.dart';
import 'package:twitter_clonex/pages/full_screen_foto.dart';

class MyPost extends StatelessWidget {
  const MyPost({super.key});
  
  @override
  Widget build(BuildContext context) {
    final User user =FirebaseAuth.instance.currentUser!;
    return  BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state is GetPostSuccess) {
           final userPosts = state.posts.where((post) => post.myUser.id == user.uid).toList();
           if (userPosts.isEmpty) {
            return const Center(child: Text("Henüz post bulunmuyor."));
          }
          userPosts.sort((a, b) => b.creadetAt.compareTo(a.creadetAt));
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: userPosts.length,
            itemBuilder: (BuildContext context, int index) {
              
              return Container(
                decoration: const BoxDecoration(
                    border: Border(
                  top: BorderSide(width: 0.1, color: Colors.grey), // Üst çizgi
                  bottom: BorderSide(width: 0.1, color: Colors.grey), // Alt çizgi
                )),
                padding: const EdgeInsets.all(8),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(userPosts[index].myUser.picture!),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          userPosts[index].myUser.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                            child: Text(userPosts[index].myUser.email,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.grey))),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          "${userPosts[index].creadetAt.day} ${getMonthName(userPosts[index].creadetAt.month)}--${userPosts[index].creadetAt.hour}:${userPosts[index].creadetAt.minute}",
                          style: const TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 48),
                      child: Text(userPosts[index].post),
                    ),
                    userPosts[index].postPic == ""
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.only(left: 48),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FullScreenImagePage(
                                              imageUrl: userPosts[index].postPic!,
                                            )));
                              },
                              child: Container(
                                height: 400,
                                width: 300,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                        image: NetworkImage(userPosts[index].postPic!))),
                              ),
                            ),
                          )
                  ],
                ),
              );
            },
          );
        } else if (state is GetPostLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return const Center(
            child: Text("Hata var"),
          );
        }
      },
    );
  }
}