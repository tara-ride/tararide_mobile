part of 'authenticate_firebase_user_bloc.dart';

sealed class AuthenticateFirebaseUserState extends Equatable {
  const AuthenticateFirebaseUserState();

  @override
  List<Object> get props => [];
}

final class AuthenticateFirebaseUserInitial extends AuthenticateFirebaseUserState {}

final class AuthenticateFirebaseUserLoading extends AuthenticateFirebaseUserState {}

final class AuthenticateFirebaseUserSuccess extends AuthenticateFirebaseUserState {
  final User user;
  final Map<String, dynamic> userData;
  const AuthenticateFirebaseUserSuccess({required this.user, required this.userData});

  @override
  List<Object> get props => [user];
}

final class AuthenticateFirebaseUserFailure extends AuthenticateFirebaseUserState {
  final String message;

  const AuthenticateFirebaseUserFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class AuthenticateFirebaseUserError extends AuthenticateFirebaseUserState {
  final String message;

  const AuthenticateFirebaseUserError(this.message);

  @override
  List<Object> get props => [message];
}
