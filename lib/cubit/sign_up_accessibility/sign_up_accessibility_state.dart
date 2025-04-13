part of 'sign_up_accessibility_cubit.dart';

sealed class SignUpAccessibilityState extends Equatable {
  const SignUpAccessibilityState();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
final class SignUpAccessibilityEnabled extends SignUpAccessibilityState {
  bool state = true;

  @override
  List<Object> get props => [state];
}

// ignore: must_be_immutable
final class SignUpAccessibilityDisabled extends SignUpAccessibilityState {
  bool state = false;

  @override
  List<Object> get props => [state];
}
