/* import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter_clonex/mobile_layout.dart';
import 'package:twitter_clonex/pages/home_page/home_screen.dart';
import 'package:twitter_clonex/services/auth_service.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FA),
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: const FaIcon(FontAwesomeIcons.xTwitter)
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const Spacer(
                flex: 30,
              ),
              const Text(
                "Şu anda dünyada olup bitenleri gör.",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
              ),
              const Spacer(
                flex: 20,
              ),
              GestureDetector(
                onTap: () {
                  AuthService().signInWithGoogle().then((value) => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeScreen(),settings: RouteSettings(arguments: value))),);
                },
                child: Container(
                  height: 50,
                  decoration:
                       BoxDecoration( borderRadius: const BorderRadius.all(Radius.circular(24)) , border: Border.all(
                        color: Colors.grey,
                        width: 0.5
                      )),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(FontAwesomeIcons.google),
                      Text("  Google ile devam et",
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16))
                    ],
                  ),
                ),
              ),
              const Text("veya"),
              Container(
                height: 50,
                decoration:
                    const BoxDecoration(color: Colors.black, borderRadius: BorderRadius.all(Radius.circular(24))),
                child: const Center(
                    child: Text(
                  "Hesap Oluşturun",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                )),
              ),
              const Spacer(
                flex: 8,
              ),
              const Text(
                  "Kaydolarak Hizmet Şartlarımızı, Gizlilik Politikamızı ve Çerez Kullanımı Politikamızı kabul etmiş olursun."),
              const Spacer(
                flex: 10,
              ),
              Row(
                children: [
                  const Text("Zaten bir hesabın var mı ?"),
                  InkWell(
                    child: const Text(" Giriş yap" ,style:TextStyle(color: Colors.blue) ,),
                    onTap: () {},
                  )
                ],
              ),
              const Spacer(
                flex: 5,
              )
            ],
          ),
        ));
  }
}
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter_clonex/blocs/sign_up_bloc/sign_up_bloc.dart';

import 'package:twitter_clonex/pages/auth_pages/registar_page.dart';

import 'package:twitter_clonex/pages/auth_pages/signin_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFFF5F8FA),
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: const FaIcon(FontAwesomeIcons.xTwitter)
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const Spacer(
                  flex: 30,
                ),
                const Text(
                  "Şu anda dünyada olup bitenleri gör.",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
                ),
                const Spacer(
                  flex: 20,
                ),
                GestureDetector(
                  onTap: () {
                   /*   AuthService().signInWithGoogle().then((value) => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeScreen(),settings: RouteSettings(arguments: value))),); */ 
                  },
                  child: Container(
                    height: 50,
                    decoration:
                         BoxDecoration( borderRadius: const BorderRadius.all(Radius.circular(24)) , border: Border.all(
                          color: Colors.grey,
                          width: 0.5
                        )),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(FontAwesomeIcons.google),
                        Text("  Google ile devam et",
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16))
                      ],
                    ),
                  ),
                ),
                const Text("veya"),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => BlocProvider.value(
      value: BlocProvider.of<SignUpBloc>(context),
      child: const RegistarPage(),
    ),
  ),
);
                  },
                  child: Container(
                    height: 50,
                    decoration:
                        const BoxDecoration(color: Colors.black, borderRadius: BorderRadius.all(Radius.circular(24))),
                    child: const Center(
                        child: Text(
                      "Hesap Oluşturun",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    )),
                  ),
                ),
                const Spacer(
                  flex: 8,
                ),
                const Text(
                    "Kaydolarak Hizmet Şartlarımızı, Gizlilik Politikamızı ve Çerez Kullanımı Politikamızı kabul etmiş olursun."),
                const Spacer(
                  flex: 10,
                ),
                Row(
                  children: [
                    const Text("Zaten bir hesabın var mı ?"),
                    InkWell(
                      child: const Text(" Giriş yap" ,style:TextStyle(color: Colors.blue) ,),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SigninPage(),));
                      },
                    )
                  ],
                ),
                const Spacer(
                  flex: 5,
                )
              ],
            ),
          )),
    );
  }
}