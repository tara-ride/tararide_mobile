import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'authenticate_firebase_user_event.dart';
part 'authenticate_firebase_user_state.dart';

class AuthenticateFirebaseUserBloc extends Bloc<AuthenticateFirebaseUserEvent, AuthenticateFirebaseUserState> {
  AuthenticateFirebaseUserBloc() : super(AuthenticateFirebaseUserInitial()) {
    on<AuthenticateFirebaseUserInitialize>((event, emit) {
      emit(AuthenticateFirebaseUserInitial());
    });

    on<AuthenticateFirebaseUserLoad>((event, emit) async {
      emit(AuthenticateFirebaseUserLoading());
      try {
        final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        if (userCredential.user != null) {
          // do the check here
          FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
          var document = firebaseFirestore.collection("account_information").doc(userCredential.user!.uid);
          DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await document.get();
          if (documentSnapshot.data() != null) {
            emit(AuthenticateFirebaseUserSuccess(user: userCredential.user!, userData: documentSnapshot.data()!));
          } else {
            emit(const AuthenticateFirebaseUserFailure("No user has been fetched."));
          }
        } else {
          emit(const AuthenticateFirebaseUserFailure("No user has been fetched."));
        }
      } on SocketException {
        emit(const AuthenticateFirebaseUserError('No internet connection'));
      } on FirebaseAuthException catch (e) {
        emit(AuthenticateFirebaseUserFailure(e.message!));
      } catch (e) {
        emit(AuthenticateFirebaseUserError(e.toString()));
      }
    });
  }
}
