part of 'authenticate_firebase_user_bloc.dart';

sealed class AuthenticateFirebaseUserEvent extends Equatable {
  const AuthenticateFirebaseUserEvent();

  @override
  List<Object> get props => [];
}

final class AuthenticateFirebaseUserInitialize extends AuthenticateFirebaseUserEvent {}

final class AuthenticateFirebaseUserLoad extends AuthenticateFirebaseUserEvent {
  final String email;
  final String password;

  const AuthenticateFirebaseUserLoad(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}
