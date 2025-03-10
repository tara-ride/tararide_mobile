part of 'user_sign_up_bloc.dart';

sealed class UserSignUpState extends Equatable {
  const UserSignUpState();

  @override
  List<Object> get props => [];
}

final class UserSignUpInitial extends UserSignUpState {}

final class UserSignUpLoading extends UserSignUpState {}

final class UserSignUpSuccess extends UserSignUpState {}

final class UserSignUpError extends UserSignUpState {
  final String message;

  const UserSignUpError(this.message);

  @override
  List<Object> get props => [message];
}
