import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clonex/blocs/get_post_bloc/get_post_bloc.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<GetPostBloc, GetPostState>(

        builder: (context, state){
          if ( state is GetPostSuccess){
               return  Center(
            child: Container(
              height: 200,
              width: 300,
              
              decoration:   BoxDecoration(color: Colors.red,
              image: DecorationImage(
                 image: NetworkImage(
                state.posts.first.postPic!
              ))),
            ),
          );
          }
          else return const Placeholder();
         
        },
      ),
    );
  }
}
