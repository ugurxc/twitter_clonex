/* 
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:message_repository/message_repository.dart';
import 'package:user_repository/user_repository.dart';

class Basic extends StatefulWidget {
  final MyUser thisUser; // Mesaj gönderen kullanıcı
  final String chatId; // Sohbetin ID'si

  const Basic({super.key, required this.thisUser, required this.chatId});

  @override
  _BasicState createState() => _BasicState();
}

class _BasicState extends State<Basic> {
  late ChatUser user; // DashChat kullanıcısı
  List<ChatMessage> messages = []; // Mesaj listesi
  late FirebaseChatRepository chatRepository; // Firestore repository

  @override
  void initState() {
    super.initState();

    chatRepository = FirebaseChatRepository();

    // ChatUser'ı başlatıyoruz
    user = ChatUser(
      profileImage:widget.thisUser.picture,
      id: widget.thisUser.id,
      firstName: widget.thisUser.name,
      lastName: widget.thisUser.email,
      
      
    );

    // Firestore'dan mesajları dinliyoruz
 chatRepository.getMessages(widget.chatId).listen((fetchedMessages) {
  if (mounted) {
    setState(() {
      messages = fetchedMessages.map((message) => ChatMessage(
        text: message.text,
        user: ChatUser(id: message.senderId),
        createdAt: message.createdAt,
        
      )).toList();
    });
  }
});

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.thisUser.picture ?? ''),
            ),
            const SizedBox(width: 8),
            Text(widget.thisUser.name),
          ],
        ),
      ),
      body: DashChat(
        
        currentUser: user,
        onSend: (ChatMessage message) {
          // Mesaj gönderildiğinde Firestore'a kaydediyoruz
          final newMessage = ChatMessageModel(
            id: '', // Firestore ID oluşturacak
            text: message.text,
            senderId: user.id,
            createdAt: message.createdAt,
          );

          chatRepository.sendMessage(newMessage, widget.chatId);
        },
        messages: messages, // Mesajları gösteriyoruz
      ),
    );
  }
} */
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:message_repository/message_repository.dart';
import 'package:user_repository/user_repository.dart';

class Basic extends StatefulWidget {
  final MyUser thisUser; // Mesaj gönderen kullanıcı
  final String chatId; // Sohbetin ID'si

  const Basic({super.key, required this.thisUser, required this.chatId});

  @override
  _BasicState createState() => _BasicState();
}

class _BasicState extends State<Basic> {
  late ChatUser user; // DashChat kullanıcısı
  List<ChatMessage> messages = []; // Mesaj listesi
  late FirebaseChatRepository chatRepository; // Firestore repository

  @override
  void initState() {
    super.initState();

    chatRepository = FirebaseChatRepository();

    // ChatUser'ı başlatıyoruz
    user = ChatUser(
      id: widget.thisUser.id,
      firstName: widget.thisUser.name,
      lastName: widget.thisUser.email,
      profileImage: widget.thisUser.picture, // Profil resmi ekliyoruz
    );

    // Firestore'dan mesajları dinliyoruz
    chatRepository.getMessages(widget.chatId).listen((fetchedMessages) {
      if (mounted) {
        setState(() {
          messages = fetchedMessages.map((message) => ChatMessage(
            text: message.text,
            user: ChatUser(
              id: message.senderId,
              profileImage: widget.thisUser.picture, // Kullanıcı profil resmi
            ),
            createdAt: message.createdAt,
          )).toList();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.thisUser.picture ?? ''),
            ),
            const SizedBox(width: 8),
            Text(widget.thisUser.name),
          ],
        ),
      ),
      body: DashChat(
        currentUser: user,
        onSend: (ChatMessage message) {
          // Mesaj gönderildiğinde Firestore'a kaydediyoruz
          final newMessage = ChatMessageModel(
            id: '', // Firestore ID oluşturacak
            text: message.text,
            senderId: user.id,
            createdAt: message.createdAt,
          );

          chatRepository.sendMessage(newMessage, widget.chatId);
        },
        messages: messages, // Mesajları gösteriyoruz

        messageOptions: const MessageOptions(
          showOtherUsersAvatar: true,
          showCurrentUserAvatar: false ,
          currentUserContainerColor: Colors.blue// Profil resmi gösterilsin
        /*   avatarBuilder: (ChatUser mUser) {
            // Mesaj gönderen kullanıcı için profil resmi göster
            return CircleAvatar(
              backgroundImage: NetworkImage(
                mUser.profileImage ?? 
                'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y', // Varsayılan resim
              ),
            );
          }, */
        ),
      ),
    );
  }
}

 
/* import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:message_repository/message_repository.dart';
import 'package:twitter_clonex/blocs/message_bloc/message_bloc.dart';

import 'package:user_repository/user_repository.dart';

 class Basic extends StatelessWidget {
  final MyUser thisUser; // Mesaj gönderen kullanıcı
  final String chatId; // Sohbetin ID'si

  const Basic({super.key, required this.thisUser, required this.chatId});

  @override
  Widget build(BuildContext context) {
    final chatRepository = FirebaseChatRepository();

    return BlocProvider(
      create: (context) => MessageBloc(messageRepository: chatRepository)..add(LoadMessages(chatId)),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(thisUser.picture ?? ''),
              ),
              const SizedBox(width: 8),
              Text(thisUser.name),
            ],
          ),
        ),
        body: BlocBuilder<MessageBloc, MessageState>(
          builder: (context, state) {
            if (state is LoadMessagesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LoadMessagesSuccess) {
              return DashChat(
                currentUser: ChatUser(
                  profileImage: thisUser.picture,
                  id: thisUser.id,
                  firstName: thisUser.name,
                  lastName: thisUser.email,
                ),
                onSend: (ChatMessage message) {
                  final newMessage = ChatMessageModel(
                    id: '', // Firestore ID oluşturacak
                    text: message.text,
                    senderId: thisUser.id,
                    createdAt: message.createdAt,
                  
                  );

                  context.read<MessageBloc>().add(SendMessage(newMessage, chatId));
                },
                messages: state.messages, // Mesajları gösteriyoruz
              );
            } else if (state is LoadMessagesFailure) {
              return const Center(child: Text("Mesajlar yüklenirken bir hata oluştu."));
            }
            return Container(); // Default olarak boş bir container döndürülür.
          },
        ),
      ),
    );
  }
}
  */

