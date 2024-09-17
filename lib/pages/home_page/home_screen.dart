/* import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = ModalRoute.of(context)!.settings.arguments as User?;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight), // AppBar yüksekliği
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20), // Sağdan ve soldan padding
            child: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              centerTitle: true,
              title: const FaIcon(FontAwesomeIcons.xTwitter),
              backgroundColor: Colors.transparent, // Arkaplanı transparan yapıyoruz
              elevation: 0, // Gölgeyi kaldırıyoruz
              leading: const Padding(
                padding: EdgeInsets.all(10.0), // Avatar etrafında padding
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/images/The_death.png"),
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            const Spacer(
              flex: 5,
            ),
            const Center(child: Text("Takip edilenler")),
            const Divider(),
            const Spacer(
              flex: 5,
            ),
            user == null ? const Text("sıkınıt var bra") : const Text("başardık"),
            const Spacer(
              flex: 100,
            )
          ],
        ));
  }
}
 */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user =ModalRoute.of(context)!.settings.arguments as User?;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight), // AppBar yüksekliği
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20), // Sağdan ve soldan padding
            child: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              centerTitle: true,
              title: const FaIcon(FontAwesomeIcons.xTwitter),
              backgroundColor: Colors.transparent, // Arkaplanı transparan yapıyoruz
              elevation: 0, // Gölgeyi kaldırıyoruz
              leading: const Padding(
                padding: EdgeInsets.all(10.0), // Avatar etrafında padding
                child: CircleAvatar(
                  backgroundImage: AssetImage(""),
                ),
              ),
            ),
          ),
        ),
        body:  Column(
          children: [
            
            const Spacer(flex: 5,),
            const Center(child: Text("Takip edilenler")),
            const Divider(),
            const Spacer(flex: 5,),
            user ==null? const Text("sıkınıt var "): ListTile(
                title: Text(user.email!  ),
            ) ,
            const Spacer(flex: 100,)
          ],
        ));
  }
}