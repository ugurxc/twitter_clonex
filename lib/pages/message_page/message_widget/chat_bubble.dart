/* import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSentByMe;
  final DateTime timestamp; 

  const ChatBubble({
    super.key,
    required this.message,
    required this.isSentByMe, required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    String formattedTime = DateFormat('HH:mm').format(timestamp);
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: screenWidth * 0.7, // En fazla %70 genişlik
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSentByMe ? Colors.blue : Colors.grey[300], // Mesaj balonu renkleri
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isSentByMe ? const Radius.circular(12) : Radius.zero,
            bottomRight: isSentByMe ? Radius.zero : const Radius.circular(12),
          ),
        ),
        child: Column(
          children: [
            Text(
              message,
              style: TextStyle(
                color: isSentByMe ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
             const SizedBox(height: 5), // Mesaj ve zaman arasında boşluk
            Text(
              formattedTime, // Zaman bilgisi
              style: TextStyle(
                color: isSentByMe ? Colors.white70 : Colors.black54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
} */
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:message_repository/message_repository.dart'; // Zaman biçimlendirme için
/*
class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSentByMe;
  final DateTime timestamp; // Zaman parametresi
  final bool isSeen; 

  const ChatBubble({
    super.key,
    required this.message,
    required this.isSentByMe,
    required this.timestamp,
    required this.isSeen, 
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Zamanı formatlamak için
    String formattedTime = DateFormat('HH:mm').format(timestamp);

    return Column(
      crossAxisAlignment: isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        // Mesaj balonu
        Align(
          alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: screenWidth * 0.7, // En fazla %70 genişlik
            ),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSentByMe ? Colors.blue : Colors.grey[300], // Mesaj balonu renkleri
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
        ),
        // Zaman göstergesi
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15), // Zamanın sağ/sol mesafesi
          child: Text(
            formattedTime,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
 

 */

class ChatBubble extends StatefulWidget {
   String message;
  final bool isSentByMe;
  final DateTime timestamp;
  final bool isSeen;
  String? pic;
  final String? audio;
  final String idDoc;
  final String senderId;
  final String receiverId;
  final ChatMessageModel messageModel;

   // Zaman parametresi
         // Görüldü bilgisi

   ChatBubble({
    super.key,
    this.pic,
    this.audio,
     this.message="",
    required this.isSentByMe,
    required this.timestamp,
    required this.isSeen,
    required this.idDoc,
    required this.senderId,
    required this.receiverId, required this.messageModel
      // Yeni eklenen parametre
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  final FirebaseChatRepository _chatRepository = FirebaseChatRepository(); 
    final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();

    // Ses süresi ve konumu dinleme
    _audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        _duration = newDuration;
      });
    });
    _audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        _position = newPosition;
      });
    });

    // Çalma durumunu dinleme
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });
  }

  void _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(widget.audio!));
    }
  }
   String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    if(widget.pic!=null){

    }
    double screenWidth = MediaQuery.of(context).size.width;
     final audioPlayer = AudioPlayer();
    // Zamanı formatlamak için
    String formattedTime = DateFormat('HH:mm').format(widget.timestamp);

    return Column(
      crossAxisAlignment: widget.isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
         if (widget.audio != null && widget.audio!.isNotEmpty)
          Align(
            alignment: widget.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
            child: GestureDetector(
              onLongPress: () {
                _showDeleteDialogForText(context);
              },
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: screenWidth * 0.7,
                ),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.isSentByMe ? Colors.blue :Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: widget.isSentByMe? Colors.white : Colors.black),
                      onPressed: _togglePlayPause,
                    ),
                    Expanded(
                      child: Slider(
                        thumbColor: widget.isSentByMe? Colors.white:Colors.black,
                        activeColor:widget.isSentByMe? Colors.white60 :const Color.fromARGB(161, 0, 0, 0),
                        inactiveColor:widget.isSentByMe? Colors.white70 : const Color.fromARGB(75, 0, 0, 0), 
                        value: _position.inSeconds.toDouble(),
                        max: _duration.inSeconds.toDouble(),
                        onChanged: (value) async {
                          await _audioPlayer.seek(Duration(seconds: value.toInt()));
                        },
                      ),
                    ),
                    Text(
                      "${_formatDuration(_position)} / ${_formatDuration(_duration)}",
                      style: TextStyle(color: widget.isSentByMe? Colors.white: Colors.black, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
        if (widget.pic != null && widget.pic!.isNotEmpty)
      Align(
        alignment: widget.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: GestureDetector(
          onLongPress: () {
            _showDeleteDialogForText(context);
          },
          child: Container(
            constraints: BoxConstraints(
              maxWidth: screenWidth * 0.7, // En fazla %70 genişlik
            ),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Image.network(
              widget.pic!,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      if(widget.message!="")
        Align(
          alignment: widget.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: GestureDetector(
            onLongPress: () {
              FocusScope.of(context).unfocus();
              _showDeleteDialogForText(context);
              
            },
            child: Container(
              constraints: BoxConstraints(
                maxWidth: screenWidth * 0.7, // En fazla %70 genişlik
              ),
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.isSentByMe ? Colors.blue : Colors.grey[300], // Mesaj balonu renkleri
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: widget.isSentByMe ? const Radius.circular(12) : Radius.zero,
                  bottomRight: widget.isSentByMe ? Radius.zero : const Radius.circular(12),
                ),
              ),
              child: Text(
                widget.message,
                style: TextStyle(
                  color: widget.isSentByMe ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        // Zaman ve görüldü göstergesi
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15), // Zamanın sağ/sol mesafesi
          child: Text(
            widget.isSentByMe  ? formattedTime : formattedTime, // Görüldü durumunu ekle
            style: TextStyle(
              color: widget.isSeen && widget.isSentByMe ? Colors.green :  Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

   void _showDeleteDialogForText(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape:RoundedRectangleBorder(
          borderRadius: BorderRadius.zero
        ),
        child: 
         Column(
          crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisSize: MainAxisSize.min,
          children: [
            if(widget.isSentByMe &&widget.message!="")
            ListTile(

              onTap: () {
                _showEditDialog(context);
                
              },
              title: Text("Mesajı düzenle"),
            ),
            if(widget.message!="")
            ListTile(
              onTap: () {
                 Clipboard.setData(ClipboardData(text: widget.message)); // Metni panoya kopyala
      
                 Navigator.of(context).pop(); // Kopyalandı bildirimi
              },
              
              title: Text("Mesaj Metnini Kopyala"),
            ),
            ListTile(
              onTap: () async{
               await _chatRepository.deleteMessageForSender(widget.idDoc, widget.senderId, widget.receiverId);
                Navigator.of(context).pop();

              },
              title: Text("Mesajı kendin için sil"),
            ),
            if(widget.isSentByMe)
            ListTile(
              onTap: () async {
              await  _chatRepository.deleteMessageForEveryone(widget.idDoc, widget.senderId, widget.receiverId);
              Navigator.of(context).pop();

              },
              title: Text("Mesajı herkes için sil"),
            ),
            if(!widget.isSentByMe)
                        ListTile(
              onTap: () {
                Navigator.pop(context);
              },
              title: Text("Mesajı bildir"),
            ),
          
          ],
        ),
  
      );
    },
  );
} 

 Future<void> _updateMessage(String newMessage) async {
  try {
    await _chatRepository.updateMessage(widget.messageModel, newMessage);
 
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mesaj güncellendi')),
    );
  } catch (e) {
    print("Mesaj güncelleme hatası: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mesaj güncellenemedi')),
    );
  }
} 
 void _showEditDialog(BuildContext context) {
  TextEditingController editingController = TextEditingController(text: widget.message);
  
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Mesajı Düzenle"),
        content: TextField(
          controller: editingController,
          maxLines: null,
          decoration: InputDecoration(hintText: "Yeni mesajınızı girin"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // İptal butonu
            },
            child: Text("İptal"),
          ),
          TextButton(
            onPressed: () async {
              String newMessage = editingController.text.trim();
              if (newMessage.isNotEmpty && newMessage != widget.message) {
                 await _updateMessage(newMessage); 
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              }
            },
            child: Text("Güncelle"),
          ),
        ],
      );
    },
  );
}

 
 void _showDeleteDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Mesajı Sil"),
        content: Text("Bu mesajı nasıl silmek istersiniz?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("İptal"),
          ),
          TextButton(
            onPressed: () {
              // Sadece Benden Sil işlemi burada yapılabilir
              // Örneğin, mesajı yalnızca kullanıcıdan gizleme
              Navigator.of(context).pop();
              // Mesaj listesinde sadece kullanıcıdan silme işlemi
              // messages.remove(message);
              // setState(() {});
            },
            child: Text("Sadece Benden Sil"),
          ),
          TextButton(
            onPressed: () {
              // Herkesten Sil işlemi burada yapılabilir
              Navigator.of(context).pop();
              // Mesajı tamamen silme işlemi
              // messages.remove(message); // veya veritabanından tamamen silme işlemi
              // setState(() {});
            },
            child: Text("Herkesten Sil", style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
} 
}
