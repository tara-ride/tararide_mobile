part of 'user_sign_up_bloc.dart';

sealed class UserSignUpEvent extends Equatable {
  const UserSignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpAwaiting extends UserSignUpEvent {}

class SignUpUser extends UserSignUpEvent {
  final String email;
  final String password;
  const SignUpUser(this.email, this.password);

  List<Object> get props => [email, password];
}
