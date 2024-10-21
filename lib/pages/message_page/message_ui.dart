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
/* import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:message_repository/message_repository.dart';
import 'package:twitter_clonex/pages/profile_page/user_profile_page.dart';
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
            InkWell(
              onTap: () {
                 Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                                
                               return UserProfilePage(thisUser: widget.thisUser) ;
                               
                },));
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.thisUser.picture ?? ''),
              ),
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
            id: '', 
            text: message.text,
            senderId: user.id,
            createdAt: message.createdAt,
          );

          chatRepository.sendMessage(newMessage, widget.chatId);
        },
        messages: messages, // Mesajları gösteriyoruz

        messageOptions: const MessageOptions(
          showOtherUsersAvatar: true,
          showCurrentUserAvatar: false,
          currentUserContainerColor: Colors.blue,// Profil resmi gösterilsin
          

        ),
        
        scrollToBottomOptions: const ScrollToBottomOptions(disabled: true),
        

      ),
    );
  }
}
 */


















/* 




import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:message_repository/message_repository.dart';
import 'package:twitter_clonex/pages/profile_page/user_profile_page.dart';
import 'package:user_repository/user_repository.dart';
import 'package:intl/intl.dart'; // DateFormat için import ekliyoruz

class Basic extends StatefulWidget {
  final MyUser thisUser; // Mesaj gönderen kullanıcı
  final String chatId; // Sohbetin ID'si
  final MyUser currentUser;
  const Basic({super.key, required this.thisUser, required this.chatId, required this.currentUser});

  @override
  _BasicState createState() => _BasicState();
}

class _BasicState extends State<Basic> {
  late final User firebasuser;
  ChatUser? currentUser; // currentUser nullable yapıldı
  ChatUser? otherUser; // otherUser nullable yapıldı
  List<ChatMessage> messages = []; // Mesaj listesi
  late FirebaseChatRepository chatRepository;

  @override
  void initState() {
    super.initState();
    firebasuser = FirebaseAuth.instance.currentUser!;
    chatRepository = FirebaseChatRepository();

    // ChatUser'ları başlatıyoruz
    otherUser = ChatUser(
      id: widget.thisUser.id,
      firstName: widget.thisUser.name,
      lastName: widget.thisUser.email,
      profileImage: widget.thisUser.picture, // Profil resmi ekliyoruz
    );

    currentUser = ChatUser(
      
      id: widget.currentUser.id,
      firstName: widget.currentUser.name,
      lastName: widget.currentUser.email,
      profileImage: widget.currentUser.picture
    
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
          // Mesajları zamana göre sıralıyoruz
          
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Eğer currentUser veya otherUser null ise yükleniyor göstergesi
    if (currentUser == null || otherUser == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return UserProfilePage(thisUser: widget.thisUser);
                }));
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.thisUser.picture ?? ''),
              ),
            ),
            const SizedBox(width: 8),
            Text(widget.thisUser.name),
          ],
        ),
      ),
      body: DashChat(
        currentUser: currentUser!, // currentUser artık null olamaz, bu yüzden '!' işaretiyle kullanıyoruz
        onSend: (ChatMessage message) {
          // Mesaj gönderildiğinde Firestore'a kaydediyoruz
          final newMessage = ChatMessageModel(
            id: '', 
            text: message.text,
            senderId: currentUser!.id, // currentUser'ı güvenli bir şekilde kullanıyoruz
            createdAt: message.createdAt,
          );

          chatRepository.sendMessage(newMessage, widget.chatId);
        },
        messages: messages, // Mesajları gösteriyoruz

        messageOptions: const MessageOptions(
          showOtherUsersAvatar: true,
          showCurrentUserAvatar: false,
          currentUserContainerColor: Colors.blue, // Profil resmi gösterilsin
          
          
        ),
        
        scrollToBottomOptions: const ScrollToBottomOptions(disabled: true),
      ),
    );
  }
}
  */
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

