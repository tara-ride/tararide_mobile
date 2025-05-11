import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'passenger_ride_status_event.dart';
part 'passenger_ride_status_state.dart';

class PassengerRideStatusBloc extends Bloc<PassengerRideStatusEvent, PassengerRideStatusState> {
  PassengerRideStatusBloc() : super(PassengerRideStatusInitial()) {
    on<PassengerRideStatusInitialize>(
      (event, emit) {
        emit(PassengerRideStatusInitial());
      },
    );

    on<PassengerSelectPickupLocation>(
      (event, emit) {
        emit(PassengerSelectingPickupLocation());
      },
    );

    on<PassengerSelectDestination>(
      (event, emit) {
        emit(PassengerSelectingDestination());
      },
    );

    on<PassengerRideStart>(
      (event, emit) {
        emit(PassengerRideStarted());
      },
    );

    on<PassengerRidePaymentStart>(
      (event, emit) {
        emit(PassengerRidePaymentStarted());
      },
    );
    on<PassengerRideFeedbackStart>(
      (event, emit) {
        emit(PassengerRideFeedbackStarted());
      },
    );

    on<PassengerRideFeedbackComplete>(
      (event, emit) {
        emit(PassengerRideFeedbackCompleted());
      },
    );
  }
}
