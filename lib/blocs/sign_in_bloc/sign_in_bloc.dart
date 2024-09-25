import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:twitter_clonex/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final UserRepository _userRepository;
  
  SignInBloc( {
  
   required UserRepository myUserRepository
  }) :_userRepository= myUserRepository , super(SignInInitial()) {
    on<SignInRequired>((event, emit) async{
      emit(SignInProcess());
      try {
        await  _userRepository.signInWithEmailPassword(event.email,event.password);
        emit(SignInSuccsess());
      } catch (e) {
        log(e.toString());
        emit(const SignInFailure());  
      }
    });
   on<SignOutRequired>((event,emit) async{

      await _userRepository.logOut();
      emit(SignOutSuccess());
      
      
    }) ;
  }
}
