import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_clonex/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:twitter_clonex/blocs/update_bloc/update_user_info_bloc.dart';

class ClickProfilePage extends StatelessWidget {
  const ClickProfilePage({super.key, required this.imageUrl});
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      
      appBar: AppBar(),
      body: 
      Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          imageUrl=="" ? Placeholder(child:Image.network('https://via.placeholder.com/400') ,)    :  Image.network(imageUrl),
          ElevatedButton(onPressed: ()async {
             final ImagePicker imagePicker = ImagePicker();
                                  final XFile? image = await imagePicker.pickImage(
                                    source: ImageSource.gallery,
                                    maxHeight: 500,
                                    maxWidth: 500,
                                    imageQuality: 40,
                                  );
                                  if (image != null) {
                                    CroppedFile? croppedFile = await ImageCropper().cropImage(
                                        sourcePath: image.path,
                                        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
                                        uiSettings: [
                                          AndroidUiSettings(
                                            toolbarTitle: 'Cropper',
                                            toolbarColor: Colors.deepOrange,
                                            toolbarWidgetColor: Colors.white,
                                            aspectRatioPresets: [
                                              CropAspectRatioPreset.original,
                                              CropAspectRatioPreset.square,
                                            ],
                                          ),
                                          IOSUiSettings(
                                            title: 'Cropper',
                                            aspectRatioPresets: [
                                              CropAspectRatioPreset.original,
                                              CropAspectRatioPreset.square,
                                              // IMPORTANT: iOS supports only one custom aspect ratio in preset list
                                            ],
                                          ),
                                        ]);
                                    if (croppedFile != null) {
                                      
                                        context
                                            .read<UpdateUserInfoBloc>()
                                            .add(UploadPicture(image.path, context.read<MyUserBloc>().state.user!.id));
                                      
                                    }
                                    Navigator.of(context).pop();
                                  }
          }, child:  Text( imageUrl=="" ?"resim ekle": "resmi değiştir" ))
        ],
      )
      
    );
  }
}