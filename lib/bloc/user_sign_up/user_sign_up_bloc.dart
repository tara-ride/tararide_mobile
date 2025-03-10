import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tararide_mobile/models/passenger.dart';

part 'user_sign_up_event.dart';
part 'user_sign_up_state.dart';

class UserSignUpBloc extends Bloc<UserSignUpEvent, UserSignUpState> {
  UserSignUpBloc() : super(UserSignUpInitial()) {
    on<UserSignUpEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<SignUpAwaiting>(
      (event, emit) {
        emit(UserSignUpInitial());
      },
    );
    on<SignUpUser>(
      (event, emit) {
        emit(UserSignUpLoading());
        try {
          // Call the API to sign up the user
          // If the API call is successful, emit UserSignUpSuccess
          // If the API call is unsuccessful, emit UserSignUpFailure
          
          emit(UserSignUpSuccess());
          //emit(UserSignUpFailure());
        } catch (e) {
          emit(UserSignUpError(e.toString()));
        }
      },
    );
  }
}
