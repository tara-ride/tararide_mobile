part of 'password_visibility_cubit.dart';

sealed class PasswordVisibilityCubitState extends Equatable {
  const PasswordVisibilityCubitState();

  @override
  List<Object> get props => [];
}

final class PasswordVisibilityActivate extends PasswordVisibilityCubitState {
  bool state = true;

  @override
  List<Object> get props => [state];
}

final class PasswordVisibilityDeactivate extends PasswordVisibilityCubitState {
  bool state = false;

  @override
  List<Object> get props => [state];
}
