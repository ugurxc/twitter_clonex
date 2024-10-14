part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object?> get props => [];
}



final class AuthUnknown extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}


 class SignInSuccsess extends AuthState{}

class SignInFailure extends AuthState{
  final String? message;

  const SignInFailure({ this.message});

}

class SignInProcess extends AuthState{}

class SignOutSuccess extends AuthState {}

class SignUpSuccsess extends AuthState{}
class SignUpFailure extends AuthState{}
class SignUpProcess extends AuthState{}
















/* enum AuthenticationStatus { authenticated, unauthenticated, unknow }

class AuthState extends Equatable {
  final AuthenticationStatus status;
  final User? user;

  const AuthState._({this.status = AuthenticationStatus.unknow, this.user});

  const AuthState.unknow() : this._();

  const AuthState.authenticated(User user) : this._(status: AuthenticationStatus.authenticated, user: user);

  const AuthState.unauthenticated() : this._(status: AuthenticationStatus.unauthenticated);
  @override
  List<Object?> get props => [];
}

 */