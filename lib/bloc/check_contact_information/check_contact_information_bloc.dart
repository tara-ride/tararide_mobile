import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'check_contact_information_event.dart';
part 'check_contact_information_state.dart';

class CheckContactInformationBloc extends Bloc<CheckContactInformationEvent, CheckContactInformationState> {
  CheckContactInformationBloc() : super(CheckContactInformationInitial()) {
    on<CheckContactInformationEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<CheckContactInformationAwaiting>((event, emit) {
      emit(CheckContactInformationInitial());
    });
    on<CheckContactInformation>((event, emit) async {
      try {
        emit(CheckContactInformationLoading());
        await Future.delayed(const Duration(seconds: 3));
        emit(CheckContactInformationSuccess('Success'));
      } catch (e) {
        emit(CheckContactInformationFailure('Failure'));
      }
    });
  }
}
