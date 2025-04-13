part of 'password_visibility_cubit.dart';

sealed class PasswordVisibilityCubitState extends Equatable {
  const PasswordVisibilityCubitState();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
final class PasswordVisibilityActivate extends PasswordVisibilityCubitState {
  bool state = true;

  @override
  List<Object> get props => [state];
}

// ignore: must_be_immutable
final class PasswordVisibilityDeactivate extends PasswordVisibilityCubitState {
  bool state = false;

  @override
  List<Object> get props => [state];
}
