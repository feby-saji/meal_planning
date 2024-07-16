part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class GoogleAuthEvent extends AuthEvent {}

class XAuthEvent extends AuthEvent {}

class FacebookAuthEvent extends AuthEvent {}
