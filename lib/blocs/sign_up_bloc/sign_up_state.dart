part of 'sign_up_bloc.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();
  
  @override
  List<Object> get props => [];
}

final class SignUpInitial extends SignUpState {}

class SignUpSuccsess extends SignUpState{}
class SignUpFailure extends SignUpState{}
class SignUpProcess extends SignUpState{}