import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'check_personal_information_event.dart';
part 'check_personal_information_state.dart';

class CheckPersonalInformationBloc extends Bloc<CheckPersonalInformationEvent, CheckPersonalInformationState> {
  CheckPersonalInformationBloc() : super(CheckPersonalInformationInitial()) {
    on<CheckPersonalInformationAwaiting>((event, emit) {});
    on<CheckPersonalInformationSubmit>((event, emit) async {
      List<String> userInterfaceValidation = [];
      try {
        emit(CheckPersonalInformationLoading());
        if (event.getLastName.isEmpty) userInterfaceValidation.add("Last Name is empty.");
        if (event.getFirstName.isEmpty) userInterfaceValidation.add("First Name is empty.");
        if (event.getBirthDate.toString() == "") userInterfaceValidation.add("Birth Date is empty.");
        await Future.delayed(const Duration(seconds: 1));

        if (userInterfaceValidation.isEmpty) {
          FirebaseFirestore firebaseFirestoreInstance = FirebaseFirestore.instance;
          var passengerDetailsCollection = firebaseFirestoreInstance.collection("passenger_details");
          passengerDetailsCollection.add({
            
          });
          emit(const CheckPersonalInformationSuccess(""));
        } else {
          emit(CheckPersonalInformationFailure(userInterfaceValidation));
        }
      } catch (e) {
        emit(CheckPersonalInformationFailure(userInterfaceValidation));
      }
    });
  }
}
