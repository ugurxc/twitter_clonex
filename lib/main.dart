import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';

import 'package:twitter_clonex/blocs/auth_bloc/auth_bloc.dart';
import 'package:twitter_clonex/blocs/bloc/post_bloc.dart';
import 'package:twitter_clonex/blocs/get_post_bloc/get_post_bloc.dart';
import 'package:twitter_clonex/blocs/my_user_bloc/my_user_bloc.dart';

import 'package:twitter_clonex/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:twitter_clonex/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:twitter_clonex/blocs/update_bloc/update_user_info_bloc.dart';
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
/* void main() async {
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
              if(state.status==AuthenticationStatus.authenticated){
                return BlocProvider(
                  create: (context) => SignInBloc(
                    myUserRepository: context.read<AuthBloc>().userRepository
                  ),
                  child: const MobileLayout(),
                );
              }
              else {return const LoginPage();}

            },
          ),
        ),
      ),
    );
  }
} */

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Ekran yönünü dikey tutma
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Bloc Observer
  Bloc.observer = SimpleBlocObserver();

  // Uygulamayı başlat
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseUserRepository userRepository = FirebaseUserRepository();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>(
          create: (_) => userRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (_) => AuthBloc(myUserRepository: userRepository),
          ),

          BlocProvider(
              create: (context) => UpdateUserInfoBloc(userRepository: context.read<AuthBloc>().userRepository)),

          BlocProvider(
            create: (context) {
              final authBloc = context.read<AuthBloc>();
              
              if (authBloc.state is AuthAuthenticated) {
                final authenticatedState = authBloc.state as AuthAuthenticated;
                return MyUserBloc(myUserRepository: authBloc.userRepository)
                  ..add(GetMyUser(myUserId: authenticatedState.user.uid));
                            }
              
              return MyUserBloc(myUserRepository: authBloc.userRepository);
            },
          ),
            BlocProvider(create: (context) => PostBloc(postRepository: FirebasePostRepository())..add(GetPost()),)
        ],
        child: MaterialApp(
          title: "Twitter Clone",
          // Aşağıya bir tema tanımlayabilirsiniz
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
             if (state is  AuthAuthenticated){
              context.read<MyUserBloc>().add(GetMyUser(myUserId: state.user.uid));
             }
            },
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthAuthenticated) {
                  
                  return const MobileLayout()  ;
                } else {
                  return const LoginPage();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
} 



          /*     if (state.status == AuthenticationStatus.authenticated) {


                
                return const MobileLayout();
              } else {
                return const LoginPage();
              }  */