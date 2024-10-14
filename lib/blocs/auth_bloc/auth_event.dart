part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationUserChanged extends  AuthEvent{
  const AuthenticationUserChanged(this.user);
  final User? user;
}

class SignUpRequired extends AuthEvent{

  final MyUser user;
  final String password;

  const SignUpRequired(this.user, this.password);
  
}

class SignInRequired extends AuthEvent{
  final String email;
  final String password;

 const  SignInRequired( this.email,  this.password);

}

class SignOutRequired extends AuthEvent{
  const SignOutRequired();
}