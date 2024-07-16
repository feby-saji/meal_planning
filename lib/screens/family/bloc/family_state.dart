part of 'family_bloc.dart';

@immutable
sealed class FamilyState {}

final class LoadingStateFamily extends FamilyState {}

final class ErrorStateFamily extends FamilyState {
  String error;
  ErrorStateFamily({required this.error});
}

// user can create or join
final class UserNotInFamily extends FamilyState {}

// show family details with members
final class UserInFamily extends FamilyState {
  final Family family;
  UserInFamily({required this.family});
}
