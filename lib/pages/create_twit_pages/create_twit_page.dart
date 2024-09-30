import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:post_repository/post_repository.dart';
import 'package:twitter_clonex/blocs/create_post_bloc/create_post_bloc.dart';
import 'package:twitter_clonex/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:user_repository/user_repository.dart';

class CreateTwitPage extends StatefulWidget {
  final MyUser myUser;
  const CreateTwitPage(this.myUser, {super.key});

  @override
  State<CreateTwitPage> createState() => _CreateTwitPageState();
}

class _CreateTwitPageState extends State<CreateTwitPage> {
  late Post post;
  final TextEditingController _textController = TextEditingController();
  @override
  void initState() {
    post = Post.empty;
    post.myUser = widget.myUser;
    super.initState();
  }

  final ImagePicker _picker = ImagePicker();
XFile? _selectedImage;

Future<String?> _uploadImage(XFile image) async {
  try {
    final storageRef = FirebaseStorage.instance.ref().child('post_images/${image.name}');
    await storageRef.putFile(File(image.path));
    return await storageRef.getDownloadURL();
  } catch (e) {
    log("Fotoğraf yükleme hatası: $e");
    return null;
  }
}

Future<void> _pickImage() async {
  try {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = pickedImage;
      });
    }
  } catch (e) {
    log("Fotoğraf seçme hatası: $e");
  }
}
  @override
  Widget build(BuildContext context) {
    return BlocListener<CreatePostBloc, CreatePostState>(
      listener: (context, state) {
        if(state is CreatePostSuccess){
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close)),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                  onPressed: () async {
                    if (_textController.text.isNotEmpty) {
    setState(() {
      post.post = _textController.text;
    });

    // Eğer fotoğraf seçildiyse önce fotoğrafı yükle
    if (_selectedImage != null) {
      String? imageUrl = await _uploadImage(_selectedImage!);
      if (imageUrl != null) {
        post = post.copyWith(postPic: imageUrl);
      }
    }

    // Sonrasında gönderiyi oluştur
    context.read<CreatePostBloc>().add(CreatePost(post));
    log(post.toString());
  }
                  },
                  child: const Text("Gönderi")),
            )
          ],
        ),
        body: BlocBuilder<MyUserBloc, MyUserState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(state.user!.picture!),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            minLines: 1,
                            maxLines: 10,
                            keyboardType: TextInputType.multiline,
                            maxLength: 200,
                            decoration: const InputDecoration(
                              hintText: "Neler oluyor?", hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none, // Varsayılan çizgiyi kaldır
                              enabledBorder: InputBorder.none, // Etkin olmayan durumdaki çizgiyi kaldır
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                  if (_selectedImage != null) 
                       Stack(
                        children: [
                          Image.file(
                            File(_selectedImage!.path),
                            width: 300,
                            height: null, // Yükseklik ayarlanabilir
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedImage = null;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.8),
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(Icons.close, color: Colors.white, size: 16),
                              ),
                            ),
                          ),
                        ],
                      ),// Seçilen fotoğrafı göster
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Fotoğraf Ekle'),
                  ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
