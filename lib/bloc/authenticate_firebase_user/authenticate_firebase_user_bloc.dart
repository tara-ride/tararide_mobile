import 'dart:io';

import 'package:bloc/bloc.dart';
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
        emit(AuthenticateFirebaseUserSuccess(userCredential.user!));
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
