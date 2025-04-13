import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sign_up_accessibility_state.dart';

class SignUpAccessibilityCubit extends Cubit<SignUpAccessibilityState> {
  SignUpAccessibilityCubit() : super(SignUpAccessibilityEnabled());

  void toggleAcessibility(bool accessible) {
    if (accessible) {
      emit(SignUpAccessibilityEnabled());
    } else {
      emit(SignUpAccessibilityDisabled());
    }
  }
}
