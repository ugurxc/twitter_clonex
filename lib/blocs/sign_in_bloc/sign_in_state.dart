/* part of 'sign_in_bloc.dart';

abstract class SignInState extends Equatable {
  const SignInState();
  
  @override
  List<Object> get props => [];
}

 class SignInInitial extends SignInState {}

 class SignInSuccsess extends SignInState{}

class SignInFailure extends SignInState{
  final String? message;

  const SignInFailure({ this.message});

}

class SignInProcess extends SignInState{}

class SignOutSuccess extends SignInState {} */