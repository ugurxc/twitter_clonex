import 'package:flutter/material.dart';
import 'package:twitter_clonex/mobile_layout.dart';
import 'package:twitter_clonex/pages/create_twit_pages/testing2.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Recorder'),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.blue.withAlpha(120),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.mic,
                    size: 100,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the recording screen
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const RecordingScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      'Start Recording',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the saved recordings screen
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const MobileLayout(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  child: const Text(
                    'View Saved Recordings',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}

/* import 'dart:io';

import "package:path/path.dart" as p;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';



class AudioTest extends StatefulWidget {
  const AudioTest({super.key});

  @override
  State<AudioTest> createState() => _AudioTestState();
}

class _AudioTestState extends State<AudioTest> {
  late AudioRecorder audioRecord;
  late AudioPlayer audioPlayer;
  bool isRecording= false;

  @override
  void initState() {
    audioPlayer=AudioPlayer();
    audioRecord=AudioRecorder();
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    audioRecord.dispose();
    super.dispose();
  }
  Future<void> startRecording() async{
    try {
      if(await audioRecord.hasPermission())
      {
        
      }
    } catch (e) {
      print("error start recording : $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(onPressed: () {
            startRecording;
          }, child: Text("start record"))
        ],
      ),
    );
  }
} */
/* class AudioTest extends StatefulWidget {
  const AudioTest({super.key});

  @override
  State<AudioTest> createState() => _AudioTestState();
}

class _AudioTestState extends State<AudioTest> {
  final AudioRecorder audioRecorder=AudioRecorder();
  final AudioPlayer audioPlayer =AudioPlayer(); 
  String? recordingPath;
  bool isRecording = false;
  bool isPlaying=false;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      floatingActionButton: _widgetRecordingButton(),
      appBar: AppBar(),
     body: _buildUI(),
    );
  }
  Widget _buildUI(){
    return SizedBox(
      width: MediaQuery.of(context).size.width/10 *5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           if(recordingPath!=null) MaterialButton(onPressed:    ()async {
             
           },color: Colors.green, child: Text(isPlaying?"durdur" : "oynat "),),
           if(recordingPath==null)
           Text("Ses bulunamadı ")
        ],
      ),
    );
  }
  Widget _widgetRecordingButton(){
    return FloatingActionButton(onPressed: () async{
      if(audioPlayer.playing){
         audioPlayer.stop();
         setState(() {
           isPlaying=false;
         });
      }
      else{
         await audioPlayer.setFilePath(recordingPath??"");
         audioPlayer.play(); 
         setState(() {
           isPlaying=true;
         });
      }
      if (isRecording) {
        String? filePath = await audioRecorder.stop();
        if(filePath!=null){
          setState(() {
            isRecording=false;
            recordingPath=filePath;
          });
        }
      }
      else{
        if( await audioRecorder.hasPermission()){
          final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
          final String filepath= p.join(appDocumentsDir.path,"recording.wav");
          await audioRecorder.start(RecordConfig(), path: filepath);
          setState(() {
            isRecording=true;
            recordingPath=null;
          });
        }
      }
      
    },child:isRecording? Icon(Icons.stop) : Icon(Icons.mic),);
  }
} */