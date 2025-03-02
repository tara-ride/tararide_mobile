import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'reset_password_countdown_event.dart';
part 'reset_password_countdown_state.dart';

class ResetPasswordCountdownBloc extends Bloc<ResetPasswordCountdownEvent, ResetPasswordCountdownState> {
  ResetPasswordCountdownBloc() : super(ResetPasswordCountdownInitial()) {
    on<ResetPasswordCountdownEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
