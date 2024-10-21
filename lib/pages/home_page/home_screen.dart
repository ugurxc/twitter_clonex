import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notif_repository/notif_repository.dart';
import 'package:twitter_clonex/blocs/auth_bloc/auth_bloc.dart';

import 'package:twitter_clonex/blocs/my_user_bloc/my_user_bloc.dart';

import 'package:twitter_clonex/blocs/update_bloc/update_user_info_bloc.dart';
import 'package:twitter_clonex/components/constant.dart';
import 'package:twitter_clonex/pages/auth_pages/login_page.dart';
import 'package:twitter_clonex/pages/full_screen_foto.dart';
import 'package:twitter_clonex/pages/profile_page/my_profile_page.dart';
import 'package:twitter_clonex/pages/profile_page/user_profile_page.dart';
import 'package:user_repository/user_repository.dart';

import '../../blocs/post_bloc/post_bloc.dart';

 class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  @override
  Widget build(BuildContext context) {
    final notifation=FirebaseNotifRepository();
    final userMyUser=FirebaseUserRepository();
    final User? userCurrent = FirebaseAuth.instance.currentUser; // Kullanıcı bilgisi alınıyor

    return BlocListener<UpdateUserInfoBloc, UpdateUserInfoState>(
      listener: (context, state) {
        if (state is UploadPictureSuccses) {
          setState(() {
            context.read<MyUserBloc>().state.user!.picture = state.userImage;
          });
        }
      },
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight), // AppBar yüksekliği
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10), // Sağdan ve soldan padding
              child: AppBar(
                systemOverlayStyle: SystemUiOverlayStyle.dark,
                centerTitle: true,
                title: const FaIcon(FontAwesomeIcons.xTwitter),
                backgroundColor: Colors.transparent, // Arkaplanı transparan yapıyoruz
                elevation: 0, // Gölgeyi kaldırıyoruz
                leading: BlocBuilder<MyUserBloc, MyUserState>(
                  builder: (context, state) {
                    if (state.status == MyUserStatus.succsess) {
                      return state.user!.picture == ""
                          ? Padding(
                              padding: const EdgeInsets.all(8),
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                                child: const Icon(Icons.person),
                              ))
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                                
                               return const MyProfilePage();
                               
                },));
                                },
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(state.user!.picture!),
                                ),
                              ),
                            );
                    }
                    return const Text("");
                  },
                ),
                actions: [
                  BlocListener<AuthBloc, AuthState>(
                    listener: (context, state) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ));
                    },
                    child: IconButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(const SignOutRequired());
                          context.read<MyUserBloc>().add(LogoutUser());
                        },
                        icon: const Icon(Icons.exit_to_app_rounded)),
                  )
                ],
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                IconButton(onPressed: () {
                  setState(() {
                    notifation.initNotifation();
                    userMyUser.getFCMToken(userCurrent!.uid);
                  });
                }, icon: const Icon(Icons.restart_alt)),
                const Center(child: Text("Takip edilenler")),
                const Divider(),

                /* user ==null? const Text("sıkınıt var "): ListTile(
                      title: Text(user.email!  )), */
                Center(
                  child: Text(userCurrent!.email!),
                ),
                Expanded(
                  child: BlocBuilder<MyUserBloc, MyUserState>(
                    builder: (context, state) {
     
                        if (state.status == MyUserStatus.loading) {
      return const Center(child: CircularProgressIndicator()); // Kullanıcı yüklenirken
    }
     if (state.status == MyUserStatus.succsess) {
      final user = state.user;

      if (user == null || user.following == null) {
        return const Center(child: Text("Kullanıcı bulunamadı veya takip edilen kimse yok."));
      }


                      return BlocBuilder<PostBloc, PostState>(
                        builder: (context, state) {
                          if (state is GetPostSuccess) {
                            final List<String> userIds = [
        ...context.read<MyUserBloc>().state.user!.following!, // Takip edilenler
        user.id                    // Current user da dahil
      ];
                            
                            final userPosts = state.posts
                                .where((post) =>
                                    userIds.contains(post.myUser.id))
                                .toList();

                            userPosts.sort((a, b) => b.creadetAt.compareTo(a.creadetAt));
                            return ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              itemCount: userPosts.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  decoration: const BoxDecoration(
                                      border: Border(
                                    top: BorderSide(width: 0.1, color: Colors.grey), // Üst çizgi
                                    bottom: BorderSide(width: 0.1, color: Colors.grey), // Alt çizgi
                                  )),
                                  padding: const EdgeInsets.all(8),
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                                
                               return userPosts[index].myUser.id!=userCurrent.uid ? UserProfilePage(thisUser: userPosts[index].myUser) : const MyProfilePage();
                               
                },));
                                            },
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(userPosts[index].myUser.picture!),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            userPosts[index].myUser.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                              child: Text(userPosts[index].myUser.email,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(color: Colors.grey))),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            "${userPosts[index].creadetAt.day} ${getMonthName(userPosts[index].creadetAt.month)}--${userPosts[index].creadetAt.hour}:${userPosts[index].creadetAt.minute}",
                                            style: const TextStyle(color: Colors.grey),
                                          )
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(left: 48),
                                        child: Text(userPosts[index].post),
                                      ),
                                      userPosts[index].postPic == ""
                                          ? const SizedBox()
                                          : Padding(
                                              padding: const EdgeInsets.only(left: 48),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => FullScreenImagePage(
                                                                imageUrl: userPosts[index].postPic!,
                                                              )));
                                                },
                                                child: Container(
                                                  height: 400,
                                                  width: 300,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(userPosts[index].postPic!))),
                                                ),
                                              ),
                                            )
                                    ],
                                  ),
                                );
                              },
                            );
                          } else if (state is GetPostLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return const Center(
                              child: Text("Hata var"),
                            );
                          }
                        },
                      );
                      
                     }
                      return const Center(child: CircularProgressIndicator());
                      },
                     
                  ),
                ),
              ],
            ),
          )),
    );
  }
} 
