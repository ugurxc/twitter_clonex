/* import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:message_repository/message_repository.dart';
import 'package:twitter_clonex/pages/message_page/message_widget/chat_bubble.dart';
import 'package:twitter_clonex/pages/message_page/message_widget/message_text_field.dart';
import 'package:twitter_clonex/pages/message_page/message_widget/voice_dialog.dart';
import 'package:user_repository/user_repository.dart';

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
    final ImagePicker _picker = ImagePicker();
XFile? _selectedImage;
  Future<void> _pickImage() async {
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
     setState(() {
      _selectedImage = image;
    });
    print("Seçilen resim yolu: ${image.path}");

    // Seçilen resmi gösterme, Firebase'e yükleme veya başka bir işlem yapabilirsiniz
  }
}
Future<String?> _uploadImage(XFile image,String userId) async {

  try {
    final storageRef = FirebaseStorage.instance.ref().child('aaaaa/PostImage/${image.name}'); //$userId/PP/${userId}_lead
    await storageRef.putFile(File(image.path));
    return await storageRef.getDownloadURL();
  } catch (e) {
    log("Fotoğraf yükleme hatası: $e");
    return null;
  }
}

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
    }
  }
    void _sendMessage() async {
      String? imageUrl;
    if (_textController.text.trim().isEmpty) return;
    if(_selectedImage!=null) {
       imageUrl = await _uploadImage(_selectedImage!,widget.senderUid);

    }
    final message = ChatMessageModel(
      senderId: widget.senderUid,
      receiverId: widget.receiverUid,
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Benzersiz bir id
      text: _textController.text.trim(),
      createdAt: DateTime.now(),
      
      picture: imageUrl,
    );
    _textController.clear();
    
    // Mesajı Firebase'e gönder
     await _chatRepository.sendMessage(
      message,
      widget.senderUid,
      widget.receiverUid,
    );
    
      setState(() {
    _selectedImage = null;
  });
     // Mesaj gönderildikten sonra inputu temizle
    _scrollToBottom(); // En yeni mesajı göstermek için sayfayı kaydır
  }
  void markAllMessagesAsSeen() async {
  final messages = await _chatRepository.getMessagesOnce(widget.senderUid, widget.receiverUid);  // Mesajları bir kere çekmek için getMessagesOnce() kullanabiliriz.
  
  for (var message in messages) {
    if (!message.isSeen && message.receiverId == widget.receiverUid) { // Eğer mesaj zaten görülmediyse
      _chatRepository.markMessageAsSeen(message.idDoc!, widget.receiverUid); // Mesajı görüldü olarak işaretle
    }
  }
}  

  

  @override
  Widget build(BuildContext context) {
   
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        
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
                    final senderMessages = messages.where((message) => message.senderId == widget.otherUser.id).toList();
                    
                          for (var message in senderMessages){
                            
                            print(senderMessages.length);
          _chatRepository.updateMessageIsSeen(message);
        }
                /*  WidgetsBinding.instance.addPostFrameCallback((_) {
                        markAllMessagesAsSeen();  // Mesajları görünce işaretle
                  });  */   
                    return ListView.builder(
                      reverse: true,
                      controller: _scrollController,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                       
                        final message = messages[index];
                        
                        return Column(
                          children: [
                            
                            ChatBubble(
                              pic: message.picture,
                              message: message.text,
                              isSentByMe: widget.senderUid == message.senderId, 
                              timestamp: message.createdAt,
                              isSeen: message.isSeen,
                              idDoc: message.idDoc!,
                              senderId: widget.senderUid,
                              receiverId: widget.receiverUid,
      
                              
                            ),
                             
                          ],
                        );
                      },
                    );
                  }
                ),
              ),
              MessageTextField(
                  prefixIcon: IconButton( onPressed: () {
                    _pickImage();
                  },icon:  const Icon(Icons.image_outlined)),
                  prefixIcon2:IconButton( onPressed: () {
                    showDialog(
                context: context,
                builder: (context) => const VoiceRecorderDialog(),
    );
                  },icon:  const Icon(Icons.multitrack_audio_outlined) ), 
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


 */

import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:message_repository/message_repository.dart';
import 'package:twitter_clonex/pages/message_page/message_widget/chat_bubble.dart';
import 'package:twitter_clonex/pages/message_page/message_widget/message_text_field.dart';
import 'package:twitter_clonex/pages/message_page/message_widget/voice_dialog.dart';
import 'package:user_repository/user_repository.dart';

class ChatScreen extends StatefulWidget {
  final String senderUid;
  final String receiverUid;
  final MyUser otherUser;

  const ChatScreen({
    super.key,
    required this.senderUid,
    required this.receiverUid,
    required this.otherUser,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  late FirebaseChatRepository _chatRepository;
  String? downloadUrlVoice;

  @override
  void initState() {
    super.initState();
    _chatRepository = FirebaseChatRepository();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {

      setState(() {
        _selectedImage = image;
      });
      print("Seçilen resim yolu: ${image.path}");
    }
  }

  Future<String?> _uploadImage(XFile image, String userId) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('aaaaa/PostImage/${image.name}');
      await storageRef.putFile(File(image.path));
      return await storageRef.getDownloadURL();
    } catch (e) {
      log("Fotoğraf yükleme hatası: $e");
      return null;
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
    }
  }

  void _sendMessage() async {
    String? imageUrl;
  if (_textController.text.trim().isEmpty && _selectedImage == null && downloadUrlVoice == null)return;
          
    if (_selectedImage != null ) {
      imageUrl = await _uploadImage(_selectedImage!, widget.senderUid);
    }

    final message = ChatMessageModel(
      senderId: widget.senderUid,
      receiverId: widget.receiverUid,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: _textController.text.trim(),
      createdAt: DateTime.now(),
      picture: imageUrl,
      audio: downloadUrlVoice,
    );

    _textController.clear();
    setState(() {
      _selectedImage = null;
      downloadUrlVoice=null;
      // Kullanım sonrası sıfırlıyoruz
    });

    await _chatRepository.sendMessage(message, widget.senderUid, widget.receiverUid);
    _scrollToBottom();
  }
  
  Future<void> _recordVoice() async {
    downloadUrlVoice = await showDialog<String>(
      context: context,
      builder: (context) => const VoiceRecorderDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.otherUser.name),
        ),
        body: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20, bottom: 10, top: 20),
          child: Column(
            children: [
              Expanded(
                child:  StreamBuilder<List<ChatMessageModel>>(
                  stream: _chatRepository.getMessages(widget.senderUid, widget.receiverUid),
                  builder: (context, snapshot) {
                     if (!snapshot.hasData) {
                      return const Center(child: Text("Henüz Text yok"),);
                    }
                    final messages = snapshot.data!;
                    final senderMessages = messages.where((message) => message.senderId == widget.otherUser.id).toList();
                    
                          for (var message in senderMessages){
                            
                            print(senderMessages.length);
          _chatRepository.updateMessageIsSeen(message);
        }
                /*  WidgetsBinding.instance.addPostFrameCallback((_) {
                        markAllMessagesAsSeen();  // Mesajları görünce işaretle
                  });  */   
                    return ListView.builder(
                      reverse: true,
                      controller: _scrollController,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                       
                        final message = messages[index];
                        
                        return Column(
                          children: [
                            
                            ChatBubble(
                              messageModel: message,
                              pic: message.picture,
                              message: message.text,
                              isSentByMe: widget.senderUid == message.senderId, 
                              timestamp: message.createdAt,
                              isSeen: message.isSeen,
                              idDoc: message.idDoc!,
                              senderId: widget.senderUid,
                              receiverId: widget.receiverUid,
                              audio: message.audio,
      
                              
                            ),
                             
                          ],
                        );
                      },
                    );
                  }
                ),
                
                /* StreamBuilder<List<ChatMessageModel>>(
                  stream: _chatRepository.getMessages(widget.senderUid, widget.receiverUid),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: Text("Henüz Text yok"));
                    }
                    final messages = snapshot.data!;
                    return ListView.builder(
                      reverse: true,
                      controller: _scrollController,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return ChatBubble(
                          pic: message.picture,
                          message: message.text,
                          isSentByMe: widget.senderUid == message.senderId,
                          timestamp: message.createdAt,
                          isSeen: message.isSeen,
                          idDoc: message.idDoc!,
                          senderId: widget.senderUid,
                          receiverId: widget.receiverUid,
                          audio: message.audio,
                        );
                      },
                    );
                  },
                ), */
              ),
              MessageTextField(
                prefixIcon: IconButton(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image_outlined),
                ),
                prefixIcon2: IconButton(
                  onPressed: _recordVoice,
                  icon: const Icon(Icons.multitrack_audio_outlined),
                ),
                suffixIcon: IconButton(
                  color: Colors.blue,
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send_outlined),
                ),
                labelText: "Şifre",
                controller: _textController,
                hintText: "Start a message",
                obscureText: false,
                keyboardType: TextInputType.multiline,
              ),
            ],
          ),
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
