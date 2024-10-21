/* 
import 'package:flutter/material.dart';
import 'package:twitter_clonex/pages/message_page/messeage_delegate.dart';

import 'package:user_repository/user_repository.dart';
 class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userRepository = FirebaseUserRepository();
    return Scaffold(
      appBar: AppBar(
        leading: const Text(""),
        title: const Text('Kullanıcı Arama'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MesseageDelegate([],userRepository), // Boş bir kullanıcı listesi başlangıç için
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Arama yapmak için üstteki arama ikonuna tıklayın'),
      ),
    );
  }
}  */
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clonex/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:twitter_clonex/pages/message_page/message_ui.dart';
import 'package:twitter_clonex/pages/message_page/message_widget/denemetest.dart';

import 'package:user_repository/user_repository.dart';
 // Kullanıcı veritabanı işlemleri

class FollowingUsersPage extends StatelessWidget {
  final UserRepository _userRepository = FirebaseUserRepository();

  FollowingUsersPage({super.key});
   // Kullanıcı veritabanı işlemleri
String getChatId(String userId1, String userId2) {
  return userId1.hashCode <= userId2.hashCode
      ? '$userId1-$userId2'
      : '$userId2-$userId1';
}
  @override
  Widget build(BuildContext context) {
    final User user =FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Takip Edilenler'),
        leading: const Text(""),
      ),
      body: BlocBuilder<MyUserBloc, MyUserState>(
        
        builder: (context, userState) {
          if (userState.status == MyUserStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final following = userState.user?.following ?? [];

          if (following.isEmpty) {
            return const Center(child: Text('Takip edilen kullanıcı yok'));
          }
          

          return FutureBuilder<List<MyUser>>(
            future: _userRepository.getUsersByIds(following), // Takip edilen kullanıcıları Firestore'dan çek
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Sonuç bulunamadı'));
              }

              final results = snapshot.data!;
              return ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(results[index].name),
                    subtitle: Text(results[index].email),
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: results[index].picture != ""
                          ? NetworkImage(results[index].picture!)
                          : const NetworkImage('https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y'),
                    ),
                    onTap: () {
                      String currentUserId = user.uid; // assuming you have the current user's ID
                      String otherUserId = results[index].id;
                      MyUser otherUser=results[index];
                      String chatId = getChatId(currentUserId, otherUserId);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return  ChatScreen(senderUid: currentUserId, receiverUid:otherUserId , otherUser: otherUser,);
                          },
                        ),
                      ); // Seçilen kullanıcı profiline gider
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
