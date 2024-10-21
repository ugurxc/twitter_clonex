
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notif_repository/notif_repository.dart';
import 'package:twitter_clonex/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:twitter_clonex/blocs/update_bloc/update_user_info_bloc.dart';
import 'package:twitter_clonex/pages/profile_page/user_post.dart';
import 'package:user_repository/user_repository.dart';

class UserProfilePage extends StatefulWidget {
  final MyUser? thisUser;
  const UserProfilePage({super.key, required this.thisUser});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    final userRepository = FirebaseUserRepository();
    final notifation=FirebaseNotifRepository();
    

    String followButtonText =
        context.read<MyUserBloc>().state.user!.isFollowing(context.read<MyUserBloc>().state.user!, widget.thisUser!.id)
            ? "Takipten Çık"
            : "Takip Et";

    return BlocListener<UpdateUserInfoBloc, UpdateUserInfoState>(
      listener: (context, state) {
             if (state is UploadPictureSuccses) {
          setState(() {
            context.read<MyUserBloc>().state.user!.picture = state.userImage;
          });
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 25,
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Positioned.fill(
                    bottom: 50,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 180,
                      color: Colors.blue,
                      child: Align(
                        alignment: Alignment.topLeft, // Konumlandırma
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30, left: 10),
                          child: Container(
                            width: 32, // Yuvarlak container'ın genişliği
                            height: 32, // Yuvarlak container'ın yüksekliği
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(255, 14, 64, 105),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20), // Geri butonu
                              onPressed: () {
                                Navigator.of(context).pop(); // Geri dönme fonksiyonu
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  BlocBuilder<MyUserBloc, MyUserState>(
                    builder: (context, state) {
                      final user = widget.thisUser;
                      if (user==null) return const Placeholder();
                      return Positioned(
                        top: 130, // Mavi alanın içine yerleştiriyoruz
                        left: 10, // Ortalamak için
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white, // Beyaz çerçeve ekleyebilirsiniz
                                    width: 4,
                                  ),
                                  image: DecorationImage(
                                    image: user.picture == ""
                                        ? const NetworkImage(
                                            'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y')
                                        : NetworkImage(user.picture!), // Profil resmi URL'si
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: followButtonText == "Takip Et"
                                        ? const WidgetStatePropertyAll(Colors.black)
                                        : const WidgetStatePropertyAll(Colors.white),
                                  ),
                                  onPressed: ()async {
                                    setState(() {
                                    if (followButtonText == "Takip Et") {
  userRepository.followUser(context.read<MyUserBloc>().state.user!, widget.thisUser!);
  followButtonText = "Takipten Çık";
  
} else {
  userRepository.unfollowUser(context.read<MyUserBloc>().state.user!, widget.thisUser!);
  followButtonText = "Takip Et";
 
}
                                    });
                                     await notifation.createNotification(
                                    NotificationModel(
                                      notificationId: "",
                                      notificationType: followButtonText == "Takip Et" ? "unfollow" : "follow",
                                      createdAt: DateTime.now(),
                                      fromUser: context.read<MyUserBloc>().state.user!,
                                      targetUserId: widget.thisUser!.id,
                                    ),
                                  );
                                  },
                                  child: Text(
                                    followButtonText,
                                    style:
                                        TextStyle(color: followButtonText == "Takip Et" ? Colors.white : Colors.black),
                                  )),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
                flex: 15,
                child: BlocBuilder<MyUserBloc, MyUserState>(
                  builder: (context, state) {
                    
                    final user = widget.thisUser;
                    if (user==null) return const Placeholder();
                    return Container(
                      padding: const EdgeInsets.only(left: 20),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name ?? "",
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                          ),
                          Text(
                            user.email ?? "gur_2003@hotmail.com",
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text("Eylül 2024 tarihinde katıldı", style: TextStyle(color: Colors.grey)),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                user.followingCount.toString(),
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              const InkWell(child: Text("Takip edilen")),
                              const SizedBox(
                                width: 12,
                              ),
                              Text(
                                user.followerCount.toString(),
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              const InkWell(child: Text("Takipçi"))
                            ],
                          )
                        ],
                      ),
                    );
                  },
                )),
            Expanded(
                flex: 45,
                child: DefaultTabController(
                  length: 4,
                  child: Scaffold(
                    body: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 10),
                            // TabBar arka plan rengi
                            child: const TabBar(
                              tabs: [
                                Tab(text: 'Gönderiler'),
                                Tab(text: 'Yanıtlar'),
                                Tab(text: 'Beğeniler'),
                                Tab(text: 'Medya'),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 400, // Her sekmenin içeriği için belirli bir yükseklik
                            child: TabBarView(
                              children: [
                                UserPost(thisUser: widget.thisUser!),
                                const Center(child: Text('Sekme 2 İçeriği')),
                                const Center(child: Text('Sekme 3 İçeriği')),
                                const Center(child: Text('Sekme 4 İçeriği')),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
