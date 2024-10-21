import 'package:flutter/material.dart';
import 'package:message_repository/message_repository.dart';
import 'package:twitter_clonex/pages/message_page/message_widget/chat_bubble.dart';
import 'package:twitter_clonex/pages/message_page/message_widget/message_text_field.dart';
import 'package:twitter_clonex/pages/message_page/message_widget/mini_profile.dart';
import 'package:user_repository/user_repository.dart';
/* class Denemetest extends StatefulWidget {
  const Denemetest({super.key});

  @override
  State<Denemetest> createState() => _DenemetestState();
}

class _DenemetestState extends State<Denemetest> {
  final TextEditingController _textEditingController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("başlık"),actions: [IconButton(onPressed: () {
        setState(() {
          
        });
        
      }, icon: const Icon(Icons.abc))],),
      body:   Column(
        children: [
          const SizedBox(height: 100,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: MessageTextField(
              prefixIcon: const Icon(Icons.image_outlined),
              prefixIcon2: const Icon(Icons.multitrack_audio_outlined),
              suffixIcon: IconButton(
                color: Colors.blue,
                onPressed: () {
                
              }, icon: const Icon(Icons.send_outlined)),
              labelText: "Şifre",
              controller: _textEditingController,
              hintText: "Start a message",
              obscureText: false,
            keyboardType: TextInputType.multiline),
          ),
        ],
      ));
    
  }
} */

/* class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSentByMe;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isSentByMe,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: screenWidth * 0.7, // Balon en fazla %70 genişliğinde olur
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSentByMe ? Colors.blue : Colors.grey[300], // Gönderilen ve alınan mesaj renkleri
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isSentByMe ? const Radius.circular(12) : Radius.zero,
            bottomRight: isSentByMe ? Radius.zero : const Radius.circular(12),
          ),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isSentByMe ? Colors.white : Colors.black,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController textEditingController=TextEditingController();
     final ScrollController _scrollController = ScrollController();
@override
void initState() {
  super.initState();
  _scrollToBottom();
}
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController=TextEditingController();
     
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20 ,vertical: 10),
        child: Column(
        
          children: [
            Expanded(
              child: ListView(
                children: const [
                  ChatBubble(message: 'Hello!', isSentByMe: false),
                  ChatBubble(message: 'Hi there! How are you doing today? I hope everything is going well.', isSentByMe: true),
                  ChatBubble(message: 'I am good, thank you! What about you?', isSentByMe: false),
                  ChatBubble(message: 'I am doing great! This is a really long message to see how the chat bubble behaves when the content is quite long and exceeds the width of 70% of the screen.', isSentByMe: true),
                  ChatBubble(message: 'Hello!', isSentByMe: false),
                  ChatBubble(message: 'Hi there! How are you doing today? I hope everything is going well.', isSentByMe: true),
                  ChatBubble(message: 'I am good, thank you! What about you?', isSentByMe: false),
                  ChatBubble(message: 'I am doing great! This is a really exceeds the width of 70% of the screen.', isSentByMe: true),
                ],
              ),
            ),
            MessageTextField(
                prefixIcon: const Icon(Icons.image_outlined),
                prefixIcon2: const Icon(Icons.multitrack_audio_outlined),
                suffixIcon: IconButton(
                  color: Colors.blue,
                  onPressed: () {
                  
                }, icon: const Icon(Icons.send_outlined)),
                labelText: "Şifre",
                controller: textEditingController,
                hintText: "Start a message",
                obscureText: false,
              keyboardType: TextInputType.multiline),
          ],
        ),
      ),
    );
  }
} */



class ChatScreen extends StatefulWidget {
    final String senderUid; // Mesajı gönderen kullanıcının UID'si
  final String receiverUid;
   final  MyUser otherUser; // Mesajı alan kullanıcının UID'si
  const ChatScreen({super.key, required this.senderUid, required this.receiverUid , required this.otherUser} );

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late FirebaseChatRepository _chatRepository;


  @override
  void initState() {
    super.initState();
    _chatRepository = FirebaseChatRepository(); 
    // Sayfa açıldığında en alta kaydırma
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
    }
  }
    void _sendMessage() async {
    if (_textController.text.trim().isEmpty) return;

    final message = ChatMessageModel(
      senderId: widget.senderUid,
      receiverId: widget.receiverUid,
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Benzersiz bir id
      text: _textController.text.trim(),
      createdAt: DateTime.now(),
    );
    _textController.clear();
    // Mesajı Firebase'e gönder
    await _chatRepository.sendMessage(
      message,
      widget.senderUid,
      widget.receiverUid,
    );

     // Mesaj gönderildikten sonra inputu temizle
    _scrollToBottom(); // En yeni mesajı göstermek için sayfayı kaydır
  }



  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        title:   Text(widget.otherUser.name),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 20, left: 20 , bottom: 10 ,top:20 ),
        child: Column(
          children: [
         /*    MiniProfile(email: widget.otherUser.email, name: widget.otherUser.name,profilPic: widget.otherUser.picture!, followers: widget.otherUser.followerCount,), */
            Expanded(
              child: StreamBuilder<List<ChatMessageModel>>(
                stream: _chatRepository.getMessages(widget.senderUid, widget.receiverUid),
                builder: (context, snapshot) {
                   if (!snapshot.hasData) {
                    return const Center(child: Text("Henüz Text yok"),);
                  }
                  final messages = snapshot.data!;
                  return ListView.builder(
                    
                    reverse: true,
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return Column(
                        children: [
                          
                          ChatBubble(

                            message: message.text,
                            isSentByMe: widget.senderUid == message.senderId, 
                            timestamp: message.createdAt,
                          ),
                        ],
                      );
                    },
                  );
                }
              ),
            ),
            MessageTextField(
                prefixIcon: const Icon(Icons.image_outlined),
                prefixIcon2: const Icon(Icons.multitrack_audio_outlined),
                suffixIcon: IconButton(
                  color: Colors.blue,
                  onPressed: _sendMessage,
                 icon: const Icon(Icons.send_outlined)),
                labelText: "Şifre",
                controller: _textController,
                hintText: "Start a message",
                obscureText: false,
              keyboardType: TextInputType.multiline),
          ],
        ),
      ),
    );
  }


  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}


