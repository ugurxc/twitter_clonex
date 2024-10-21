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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Zaman biçimlendirme için

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSentByMe;
  final DateTime timestamp; // Zaman parametresi

  const ChatBubble({
    super.key,
    required this.message,
    required this.isSentByMe,
    required this.timestamp,
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
 


