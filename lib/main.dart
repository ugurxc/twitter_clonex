import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clonex/blocs/auth_bloc/auth_bloc.dart';
import 'package:twitter_clonex/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:twitter_clonex/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:twitter_clonex/mobile_layout.dart';
import 'package:twitter_clonex/pages/auth_pages/login_page.dart';


import 'package:twitter_clonex/simple_bloc_observer.dart';
import 'package:user_repository/user_repository.dart';


/* void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Bloc.observer = SimpleBlocObserver();
  runApp( MyApp(FirebaseUserRepository()));}

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  const MyApp(this.userRepository,{super.key});

  @override
  Widget build(BuildContext context) {
    return  MultiRepositoryProvider(
      providers:[ RepositoryProvider<AuthBloc>(
        create: (_)=> AuthBloc(myUserRepository: userRepository))],
      child: MaterialApp(
          title: "twitterclone",
          home: BlocBuilder<AuthBloc,AuthState>(
            builder: (context,state){
                if(state.status == AuthenticationStatus.authenticated){
                  return const MobileLayout();
                }
                else{
                  return const LoginPage();
                }
            })
      ));
  }
} */
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp(FirebaseUserRepository()));
}

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  const MyApp(this.userRepository, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthBloc>(
          create: (_) => AuthBloc(myUserRepository: userRepository),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
           BlocProvider<SignInBloc>(
      create: (_) => SignInBloc(myUserRepository: userRepository),
    ),
          BlocProvider<SignUpBloc>(
            create: (context) => SignUpBloc(userRepository),
          ),
        ],
        child: MaterialApp(
          title: "twitterclone",
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state.status == AuthenticationStatus.authenticated) {
                return const MobileLayout();
              } else {
                return const LoginPage();
              } 

            },
          ),
        ),
      ),
    );
  }
}