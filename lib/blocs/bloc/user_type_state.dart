part of 'user_type_bloc.dart';

@immutable
sealed class UserTypeState {}

final class UserTypeInitial extends UserTypeState {}

final class UserTypeLoadingState extends UserTypeState {}

final class FreeUserState extends UserTypeState {}

final class PremiumUserState extends UserTypeState {}