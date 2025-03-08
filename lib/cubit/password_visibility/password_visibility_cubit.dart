import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'password_visibility_state.dart';

class PasswordVisibilityCubit extends Cubit<PasswordVisibilityCubitState> {
  PasswordVisibilityCubit() : super(PasswordVisibilityDeactivate());

  void toggleVisibility(bool visibility) {
    if (visibility) {
      emit(PasswordVisibilityActivate());
    } else {
      emit(PasswordVisibilityDeactivate());
    }
  }
}
