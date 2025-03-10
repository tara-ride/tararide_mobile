import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'check_personal_information_event.dart';
part 'check_personal_information_state.dart';

class CheckPersonalInformationBloc extends Bloc<CheckPersonalInformationEvent, CheckPersonalInformationState> {
  CheckPersonalInformationBloc() : super(CheckPersonalInformationInitial()) {
    on<CheckPersonalInformationEvent>((event, emit) async {
      // TODO: implement event handler
    });

    on<CheckPersonalInformationAwaiting>((event, emit) {});
    on<CheckPersonalInformationSubmit>((event, emit) async {
      try {
        emit(CheckPersonalInformationLoading());
        await Future.delayed(const Duration(seconds: 2));
        emit(const CheckPersonalInformationSuccess('Success'));
      } catch (e) {
        emit(CheckPersonalInformationFailure(e.toString()));
      }
    });
  }
}
