
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'check_account_information_event.dart';
part 'check_account_information_state.dart';

class CheckAccountInformationBloc extends Bloc<CheckAccountInformationEvent, CheckAccountInformationState> {
  CheckAccountInformationBloc() : super(CheckAccountInformationInitial()) {
    on<CheckAccountInformationAwaiting>((event, emit) async {
      emit(CheckAccountInformationInitial());
    });

    on<CheckAccountInformation>((event, emit) async {
      List<String> errorLogs = [];
      try {
        emit(CheckAccountInformationLoading());
        await Future.delayed(const Duration(seconds: 1));
        FirebaseAuth firebaseAuthInstance = FirebaseAuth.instance;
        FirebaseFirestore firebaseFirestoreInstance = FirebaseFirestore.instance;

        //Step 1: make sure there is no user signed in.
        //Step 2: If there is a user signed in. Sign out the account.
        var currentUser = firebaseAuthInstance.currentUser;
        if (currentUser != null) {
          errorLogs.add("User currently exists");
          await firebaseAuthInstance.signOut();
        }

        //Step 3: initiate check for e-mail address.
        if (event.email.isEmpty) {
          errorLogs.add("E-mail Address is empty.");
        }
        if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(event.email)) {
          errorLogs.add("E-mail Address format is incorrect.");
        }
        //Step 4: initiate check for password.

        if (event.password.isEmpty) {
          errorLogs.add("Password is Empty");
        }
        if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$').hasMatch(event.password)) {
          errorLogs.add("Password must contain at least 1 uppercase letter, 1 lowercase letter, and 1 number");
        }
        if (event.password.length > 50) {
          errorLogs.add("Password must be at most 50 characters long");
        }
        if (event.password.length < 8) {
          errorLogs.add("Password must be at least 8 characters long");
        }
        if ((event.password.length != event.retypePassword.length) && (event.password != event.retypePassword)) {
          errorLogs.add("Passwords do not match. Please retry.");
        }

        //Step 5: Once clear. Initiate e-mail address check for existing, get data from account_information table.
        //var getAccountInformation = firebaseFirestoreInstance.collection("account_information");
        // var getAlldocs = await getAccountInformation.get();
        // print();
        //Step 6: if existing, provide error.
        //Step 7: if not, then proceed to upload account_information and firebase authentication.
        //Step 8: compile activities, if error logs is empty, then emit success state. Emit error if otherwise.

        if (errorLogs.isEmpty) {
          emit(const CheckAccountInformationSuccess("Login Successful"));
        } else {
          emit(CheckAccountInformationFailure(errorLogs));
        }
      } catch (e) {
        emit(CheckAccountInformationFailure(errorLogs));
      }
    });
  }
}
