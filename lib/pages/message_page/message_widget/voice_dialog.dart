import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class VoiceRecorderDialog extends StatefulWidget {
  const VoiceRecorderDialog({super.key});

  @override
  _VoiceRecorderDialogState createState() => _VoiceRecorderDialogState();
}

class _VoiceRecorderDialogState extends State<VoiceRecorderDialog> {
  final _audioRecorder = FlutterSoundRecorder();
  bool _isRecording = false;
  bool _recorderIsReady = false;
  String _filePath = '';
  Duration _recordDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    final requestStatus = await Permission.microphone.request();

    if (requestStatus != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Microphone permission denied'),
          backgroundColor: Colors.red,
        ),
      );
      throw ('Microphone permission denied');
    }

    await _audioRecorder.openRecorder();
    _recorderIsReady = true;
    _audioRecorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _audioRecorder.closeRecorder();
    super.dispose();
  }

  Future<void> _startRecording(Function setState) async {
    if (!_recorderIsReady) return;

    final Directory appDocDirectory = await getApplicationDocumentsDirectory();
    final String filePath = '${appDocDirectory.path}/recording.aac';

    await _audioRecorder.startRecorder(
      toFile: filePath,
      codec: Codec.aacADTS,
    );

    setState(() {
      _isRecording = true;
      _filePath = filePath;
      _recordDuration = Duration.zero;
    });

    _audioRecorder.onProgress!.listen((event) {
      setState(() {
        _recordDuration = event.duration;
      });
    });
  }

  Future<void> _stopRecording(Function setState) async {
    if (!_recorderIsReady) return;

    setState(() {
      _isRecording = false;
    });

    await _audioRecorder.stopRecorder();
  }

/*   Future<String?> _saveRecordingToFirebase(BuildContext dialogContext) async {
    try {
      if (_filePath.isNotEmpty) {
        final File audioFile = File(_filePath);
        final String fileName =
            'recordings/${DateTime.now().millisecondsSinceEpoch}.aac';

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Saving file to Firebase...'),
          ),
        );

        // Firebase Storage'a dosyayı yükle
        final storageRef = FirebaseStorage.instance.ref(fileName);
        await storageRef.putFile(audioFile);

        // İndirme URL'sini al
        final downloadUrl = await storageRef.getDownloadURL();

        // Firestore'a URL’yi kaydet


        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Recording saved to Firebase successfully!'),
            backgroundColor: Colors.green,
          ),
        );
         Navigator.of(dialogContext).pop();
        return downloadUrl;

        // Kayıt tamamlandığında dialog'u kapat
      } else {
        throw Exception('No recording found to save.');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save recording to Firebase.'),
          backgroundColor: Colors.red,
        ),
      );
    }
    return null;
  }
 */
/* Future<String> _saveRecordingToFirebase(BuildContext dialogContext) async {
  try {
    if (_filePath.isNotEmpty) {
      final File audioFile = File(_filePath);
      if (!await audioFile.exists()) {
        throw Exception('Recording file does not exist at $_filePath');
      }

      final String fileName = 'recordings/${DateTime.now().millisecondsSinceEpoch}.aac';

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saving file to Firebase...')),
      );

      // Firebase Storage'a dosyayı yükle
      final storageRef = FirebaseStorage.instance.ref(fileName);
      await storageRef.putFile(audioFile);

      // İndirme URL'sini al
      final downloadUrl = await storageRef.getDownloadURL().catchError((error) {
        print('Error getting download URL: $error');
       
      });
      print("Download URL: $downloadUrl");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recording saved to Firebase successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(dialogContext).pop();
      return downloadUrl;
    } 
    return "";
  } catch (error) {
    print('Error in _saveRecordingToFirebase: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Failed to save recording to Firebase.'),
        backgroundColor: Colors.red,
        
      ),
    );
  }

} */
Future<String> _saveRecordingToFirebase(BuildContext dialogContext) async {
  try {
    if (_filePath.isNotEmpty) {
      final File audioFile = File(_filePath);
      final int sayi=20;
      print("$sayi");

      // Dosyanın mevcut olup olmadığını kontrol et
      if (!await audioFile.exists()) {
        throw Exception('Recording file does not exist at $_filePath');
      }

      final String fileName = 'recordings/${DateTime.now().millisecondsSinceEpoch}.aac';

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saving file to Firebase...')),
      );

      // Dosyayı Firebase Storage'a yükle
      final storageRef = FirebaseStorage.instance.ref(fileName);
      await storageRef.putFile(audioFile);

      // İndirme URL'sini al
      final downloadUrl = await storageRef.getDownloadURL().catchError((error) {
        print('Error getting download URL: $error');
        throw Exception('Failed to get download URL: $error');
      });
      
      print("Download URL: $downloadUrl");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recording saved to Firebase successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.of(dialogContext).pop(downloadUrl);
      
      // İndirme URL'sini döndür
      return downloadUrl;
    } else {
      throw Exception('Recording file path is empty.');
    }
  } catch (error) {
    print('Error in _saveRecordingToFirebase: $error');

    // Kullanıcıya hata mesajı göster
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Failed to save recording to Firebase.'),
        backgroundColor: Colors.red,
      ),
    );

    // Hata fırlat veya default bir değer döndür
    throw Exception('Failed to save recording to Firebase: $error');
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
    return AlertDialog(
      title: const Text("Voice Recording"),
      content: StatefulBuilder(
        builder: (context, setState) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isRecording)
              Text(
                "Recording... ${_formatDuration(_recordDuration)}",
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                if (_isRecording) {
                  await _stopRecording(setState);
                   final String audioString= await _saveRecordingToFirebase(context);
                   print(audioString);
                } else {
                  _startRecording(setState);
                }
              },
              child: Text(_isRecording ? 'Stop & Save' : 'Start Recording'),
            ),
          ],
        ),
      ),
    );
  }
}
