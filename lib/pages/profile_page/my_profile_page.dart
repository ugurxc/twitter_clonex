
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clonex/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:twitter_clonex/blocs/update_bloc/update_user_info_bloc.dart';
import 'package:twitter_clonex/pages/profile_page/click_profile_page.dart';
import 'package:twitter_clonex/pages/profile_page/my_post.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MYProfilePageState();
}

class _MYProfilePageState extends State<MyProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
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
                BlocListener<UpdateUserInfoBloc , UpdateUserInfoState>(
                  listener: (context, state) {
                if(state is UploadPictureSuccses){
          setState(() {
            context.read<MyUserBloc>().state.user!.picture=state.userImage;
          });
        }
                  },
                  child: BlocBuilder<MyUserBloc, MyUserState>(
                    builder: (context, state) {
                      return Positioned(
                        top: 130, // Mavi alanın içine yerleştiriyoruz
                        left: 10, // Ortalamak için
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ClickProfilePage(
                                imageUrl: state.user?.picture ?? 'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y',
                              ),
                            ));
                          },
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white, // Beyaz çerçeve ekleyebilirsiniz
                                width: 4,
                              ),
                              image: DecorationImage(
                                image: state.user!.picture == ""
                                    ? const NetworkImage('https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y')
                                    : NetworkImage(state.user!.picture!), // Profil resmi URL'si
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              flex: 2,
              child: BlocBuilder<MyUserBloc, MyUserState>(
                builder: (context, state) {
                  return Container(
                    padding: const EdgeInsets.only(left: 20),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.user?.name ?? "gur",
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                        ),
                        Text(
                          state.user?.email ?? "gur_2003@hotmail.com",
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
                              state.user!.followingCount.toString(),
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
                              state.user!.followerCount.toString(),
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
              flex: 5,
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
                        const SizedBox(
                          height: 400, // Her sekmenin içeriği için belirli bir yükseklik
                          child: TabBarView(
                            children: [
                              MyPost(),
                              Center(child: Text('Sekme 2 İçeriği')),
                              Center(child: Text('Sekme 3 İçeriği')),
                              Center(child: Text('Sekme 4 İçeriği')),
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
    );
  }
}
