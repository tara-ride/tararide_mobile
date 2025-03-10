import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'check_account_information_event.dart';
part 'check_account_information_state.dart';

class CheckAccountInformationBloc extends Bloc<CheckAccountInformationEvent, CheckAccountInformationState> {
  CheckAccountInformationBloc() : super(CheckAccountInformationInitial()) {
    on<CheckAccountInformationEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<CheckAccountInformationAwaiting>((event, emit) async {
      emit(CheckAccountInformationInitial());
    });

    on<CheckAccountInformation>((event, emit) async {
      try {
        emit(CheckAccountInformationLoading());
        await Future.delayed(Duration(seconds: 2));
        emit(const CheckAccountInformationSuccess("Login Successful"));
      } catch (e) {
        emit(CheckAccountInformationFailure("Login Failed with error: $e"));
      }
    });
  }
}
