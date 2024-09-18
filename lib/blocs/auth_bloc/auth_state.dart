part of 'auth_bloc.dart';

enum AuthenticationStatus { authenticated, unauthenticated, unknow }

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
