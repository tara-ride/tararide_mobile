import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'determine_user_category_event.dart';
part 'determine_user_category_state.dart';

class DetermineUserCategoryBloc extends Bloc<DetermineUserCategoryEvent, DetermineUserCategoryState> {
  DetermineUserCategoryBloc() : super(DetermineUserCategoryInitial()) {
    on<DetermineUserCategoryEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
