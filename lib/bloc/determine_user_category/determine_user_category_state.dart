part of 'determine_user_category_bloc.dart';

sealed class DetermineUserCategoryState extends Equatable {
  const DetermineUserCategoryState();

  @override
  List<Object> get props => [];
}

final class DetermineUserCategoryInitial extends DetermineUserCategoryState {
  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
final class DetermineUserCategoryLoading extends DetermineUserCategoryState {
  User user;
  DetermineUserCategoryLoading({required this.user});
  @override
  List<Object> get props => [user];
}

final class DetermineUserCategoryComplete extends DetermineUserCategoryState {}
