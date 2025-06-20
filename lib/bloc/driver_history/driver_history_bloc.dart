import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tararide_mobile/models/ride_information_data.dart';
import 'package:tararide_mobile/repository/driver_ride_information_repository.dart';

part 'driver_history_event.dart';
part 'driver_history_state.dart';

class DriverHistoryBloc extends Bloc<DriverHistoryEvent, DriverHistoryState> {
  DriverHistoryBloc() : super(DriverHistoryInitial()) {
    DriverRideInformationRepositoryImplementation driverRideInformationRepositoryImplementation = DriverRideInformationRepositoryImplementation();
    StreamSubscription? _streamSubscription;
    on<DriverHistoryEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<DriverHistoryLoadList>((event, emit) {
      if (_streamSubscription != null) {
        _streamSubscription!.cancel();
      }
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;

      if (firebaseAuth.currentUser != null) {
        _streamSubscription = driverRideInformationRepositoryImplementation.getRideinformationList(firebaseAuth.currentUser!.uid).listen((onValue) {
          add(DriverHistoryDisplayList(rideInformationList: onValue));
        });
      }
    });

    on<DriverHistoryDisplayList>((event, emit) {
      emit(DriverHistoryListLoaded(rideInformationList: event.rideInformationList));
    });
  }
}
