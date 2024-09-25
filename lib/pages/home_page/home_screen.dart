import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';





import 'package:twitter_clonex/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:twitter_clonex/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:twitter_clonex/blocs/update_bloc/update_user_info_bloc.dart';
import 'package:twitter_clonex/pages/auth_pages/login_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    
    final User? user = FirebaseAuth.instance.currentUser; // Kullanıcı bilgisi alınıyor

    return BlocListener<UpdateUserInfoBloc, UpdateUserInfoState>(
      listener: (context, state) {
        if(state is UploadPictureSuccses){
          setState(() {
            context.read<MyUserBloc>().state.user!.picture=state.userImage;
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
                              padding: const EdgeInsets.all(8),
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    
                                    shape: BoxShape.circle,
                                    image: DecorationImage(image: NetworkImage(state.user!.picture!))),
                              ),
                            );
                    }
                    return const Text("");
                  },
                ),
                actions: [
                  BlocListener<SignInBloc, SignInState>(
                    listener: (context, state) {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginPage(),));
                      
                    },
                    child: IconButton(
                        onPressed: () {
                          context.read<SignInBloc>().add(const SignOutRequired());
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
                  
                }, icon: const Icon(Icons.restart_alt)),
                const Center(child: Text("Takip edilenler")),
                const Divider(),

                /* user ==null? const Text("sıkınıt var "): ListTile(
                      title: Text(user.email!  )), */
                Center(
                  child: Text(user!.email!),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: 4,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: const EdgeInsets.all(8),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  "ugurbulak",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                    child: Text(
                                  user.email!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )),
                                const SizedBox(
                                  width: 20,
                                ),
                                const Text("50 dk")
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 48),
                              child: const Text(
                                  ''' Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis quis risus placerat, aliquet velit ac, porta erat. Sed ornare suscipit metus vel eleifend. Phasellus rutrum tellus in nisl pretium dictum. Maecenas in ante purus. Fusce eget bibendum risus, eu auctor dolor. Maecenas nec diam pulvinar nisi posuere varius et in. '''),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
