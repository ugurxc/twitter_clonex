import 'dart:async';
import 'dart:developer';



import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';



import 'package:user_repository/user_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository userRepository;
  late final StreamSubscription<User?> _userSubscription;
  AuthBloc({
    required UserRepository myUserRepository
  }) :userRepository=myUserRepository ,super( AuthUnknown()) {
    _userSubscription=userRepository.user.listen((authUser) {
      add(AuthenticationUserChanged(authUser));
    },);
    
    on<AuthenticationUserChanged>((event, emit) async {
        
          if(event.user!=null){
            emit(AuthAuthenticated(event.user!));
            
          }
          else{
            emit( AuthUnauthenticated());
          }

    });
        on<SignInRequired>((event, emit) async{
      emit(SignInProcess());
      try {
        await  myUserRepository.signInWithEmailPassword(event.email,event.password);
        emit(SignInSuccsess());
      } catch (e) {
        log(e.toString());
        emit(const SignInFailure());  
      }
    });
        on<SignUpRequired>((event, emit) async{
      emit(SignUpProcess());
      try {
        MyUser user = await myUserRepository.signUpWithEmailPassword(event.user, event.password) ;
        await myUserRepository.setUserData(user);
        emit(SignUpSuccsess());
      } catch (e) {
        log(e.toString());
        emit(SignUpFailure());
      }
    });
       on<SignOutRequired>((event,emit) async{

      await myUserRepository.logOut();
      emit(SignOutSuccess());
      
      
    }) ;
  }
  @override
  Future<void> close(){
    _userSubscription.cancel();
    return super.close();
  }
}
