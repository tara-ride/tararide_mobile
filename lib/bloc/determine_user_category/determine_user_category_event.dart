part of 'determine_user_category_bloc.dart';

sealed class DetermineUserCategoryEvent extends Equatable {
  const DetermineUserCategoryEvent();

  @override
  List<Object> get props => [];
}

final class DetermineUserCategoryAwait extends DetermineUserCategoryEvent {
  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
final class DetermineUserCategoryLoad extends DetermineUserCategoryEvent {
  User user;
  DetermineUserCategoryLoad({required this.user});

  @override
  List<Object> get props => [user];
}
