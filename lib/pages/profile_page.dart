import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clonex/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:twitter_clonex/pages/auth_pages/login_page.dart';
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignOutSuccess) {
          // Çıkış yapıldı, giriş sayfasına yönlendir
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginPage(),));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Profile Page'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Çıkış event'ini tetikleyin
                  context.read<SignInBloc>().add(const SignOutRequired());
                },
                child: const Text('Çıkış Yap'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
