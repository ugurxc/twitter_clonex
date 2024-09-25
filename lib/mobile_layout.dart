import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


import 'package:twitter_clonex/blocs/auth_bloc/auth_bloc.dart';

import 'package:twitter_clonex/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:twitter_clonex/pages/create_twit_pages/create_twit_page.dart';

import 'package:twitter_clonex/pages/deneme.dart';

import 'package:twitter_clonex/pages/home_page/home_screen.dart';
import 'package:twitter_clonex/pages/message_page/message_screen.dart';
import 'package:twitter_clonex/pages/notifications_page/notifications_screen.dart';

import 'package:twitter_clonex/pages/profile_page/profile_page.dart';


class MobileLayout extends StatefulWidget {
  const MobileLayout({
    super.key,
  });

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  
  final PageController _pageController = PageController();
  var _currentIndex = 0;

  

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if(state.status==AuthenticationStatus.authenticated){
          
          setState(() {
            MyUserBloc(myUserRepository: context.read<AuthBloc>().userRepository).add(GetMyUser(myUserId: context.read<AuthBloc>().state.user!.uid));
          });
            
        }
      },
      child: Scaffold(
          drawer: BlocBuilder<MyUserBloc, MyUserState>(
            builder: (context, state) {
              if (state.status == MyUserStatus.succsess) {
                return Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      DrawerHeader(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(state.user!.picture!),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => const ProfilePage(),
                                    ));
                                  },
                                ),
                              ),
                              Text(
                                maxLines: 1,
                                state.user!.name,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(state.user!.email,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 96, 96, 96),
                                    fontSize: 14,
                                  )),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text("0 Takip edilen    0 Takipçi",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 96, 96, 96),
                                    fontSize: 14,
                                  ))
                            ],
                          )),
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                        leading: const Icon(Icons.home),
                        title: const Text('Anasayfa'),
                        onTap: () {
                          // Anasayfa aksiyonu
                        },
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                        leading: const Icon(Icons.settings),
                        title: const Text('Ayarlar'),
                        onTap: () {
                          // Ayarlar aksiyonu
                        },
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                        leading: const Icon(Icons.home),
                        title: const Text('Anasayfa'),
                        onTap: () {
                          // Anasayfa aksiyonu
                        },
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                        leading: const Icon(Icons.settings),
                        title: const Text('Ayarlar'),
                        onTap: () {
                          // Ayarlar aksiyonu
                        },
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                        leading: const Icon(Icons.home),
                        title: const Text('Anasayfa'),
                        onTap: () {
                          // Anasayfa aksiyonu
                        },
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                        leading: const Icon(Icons.settings),
                        title: const Text('Ayarlar'),
                        onTap: () {
                          // Ayarlar aksiyonu
                        },
                      ),
                    ],
                  ),
                );
              } else if (state.status == MyUserStatus.loading || state.status == MyUserStatus.failure) {
                return const CircularProgressIndicator();
              }
              return const Drawer();
            },
          ),
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [HomeScreen(), TabBarExample(), NotificationsScreen(), MessageScreen()],
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: const Color(0xFFF5F8FA),
            currentIndex: _currentIndex,
            onTap: (int index) {
              _pageController.jumpToPage(index);
              setState(() => _currentIndex = index);
            },
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false, // Label'leri gizle
            showUnselectedLabels: false, // Seçilmeyen item label'lerini de gizle
            selectedItemColor: Colors.black, // Seçili olan item rengi
            unselectedItemColor: Colors.black.withOpacity(0.6), // Seçili olmayan itemlar için siyah
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home_outlined,
                  ),
                  label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.search_outlined), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.notifications_none_outlined), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.message_outlined), label: ''),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blue, 
  foregroundColor: Colors.white, 
            shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(30)),  onPressed: () {
            Navigator.push(context,
             MaterialPageRoute<void>(builder: (BuildContext context)=>const CreateTwitPage()));
          },child: const FaIcon(FontAwesomeIcons.twitter),),

          // drawerEdgeDragWidth: MediaQuery.of(context).size.width, // Ekranın tamamını kaydırarak açma
          ),
    );
  }
}
      
    






 













 

/* import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clonex/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:twitter_clonex/pages/auth_pages/login_page.dart';
import 'package:twitter_clonex/pages/home_page/home_screen.dart';
import 'package:twitter_clonex/pages/message_page/message_screen.dart';
import 'package:twitter_clonex/pages/notifications_page/notifications_screen.dart';
import 'package:twitter_clonex/pages/search_page/search_screen.dart';

class MobileLayout extends StatefulWidget {
  const MobileLayout({
    super.key,
  });

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  final PageController _pageController = PageController();
  var _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginPage(),));
      },
      child: Scaffold(
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                const DrawerHeader(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(""),
                        ),
                        Text(
                          maxLines: 1,
                          "",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text("Email bilgisi yok",
                            style: TextStyle(
                              color: Color.fromARGB(255, 96, 96, 96),
                              fontSize: 14,
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Text("0 Takip edilen    0 Takipçi",
                            style: TextStyle(
                              color: Color.fromARGB(255, 96, 96, 96),
                              fontSize: 14,
                            ))
                      ],
                    )),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  leading: const Icon(Icons.home),
                  title: const Text('Anasayfa'),
                  onTap: () {
                    // Anasayfa aksiyonu
                  },
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  leading: const Icon(Icons.settings),
                  title: const Text('Ayarlar'),
                  onTap: () {
                    // Ayarlar aksiyonu
                  },
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  leading: const Icon(Icons.home),
                  title: const Text('Anasayfa'),
                  onTap: () {
                    // Anasayfa aksiyonu
                  },
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  leading: const Icon(Icons.settings),
                  title: const Text('Ayarlar'),
                  onTap: () {
                    // Ayarlar aksiyonu
                  },
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  leading: const Icon(Icons.home),
                  title: const Text('Anasayfa'),
                  onTap: () {
                    // Anasayfa aksiyonu
                  },
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  leading: const Icon(Icons.settings),
                  title: const Text('Ayarlar'),
                  onTap: () {
                    // Ayarlar aksiyonu
                  },
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  leading: const Icon(Icons.home),
                  title: const Text('Çıkış Yap'),
                  onTap: () {
                    context.read<SignInBloc>().add(const SignOutRequired());
                  },
                ),
              ],
            ),
          ),
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [HomeScreen(), SearchScreen(), NotificationsScreen(), MessageScreen()],
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: const Color(0xFFF5F8FA),
            currentIndex: _currentIndex,
            onTap: (int index) {
              _pageController.jumpToPage(index);
              setState(() => _currentIndex = index);
            },
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false, // Label'leri gizle
            showUnselectedLabels: false, // Seçilmeyen item label'lerini de gizle
            selectedItemColor: Colors.black, // Seçili olan item rengi
            unselectedItemColor: Colors.black.withOpacity(0.6), // Seçili olmayan itemlar için siyah
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home_outlined,
                  ),
                  label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.search_outlined), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.notifications_none_outlined), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.message_outlined), label: ''),
            ],
          )

          // drawerEdgeDragWidth: MediaQuery.of(context).size.width, // Ekranın tamamını kaydırarak açma
          ),
    );
  }
} */