/* import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserRepository _userRepository;
  SignUpBloc(UserRepository myUserRepository) : _userRepository=myUserRepository, super(SignUpInitial()) {
    on<SignUpRequired>((event, emit) async{
      emit(SignUpProcess());
      try {
        MyUser user = await _userRepository.signUpWithEmailPassword(event.user, event.password) ;
        await _userRepository.setUserData(user);
        emit(SignUpSuccsess());
      } catch (e) {
        log(e.toString());
        emit(SignUpFailure());
      }
    });
  }
}
 */