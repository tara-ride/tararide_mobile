part of 'reset_password_countdown_bloc.dart';

sealed class ResetPasswordCountdownState extends Equatable {
  const ResetPasswordCountdownState();
  
  @override
  List<Object> get props => [];
}

final class ResetPasswordCountdownInitial extends ResetPasswordCountdownState {}
