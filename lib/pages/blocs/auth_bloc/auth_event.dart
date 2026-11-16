part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}


class LodingEvent extends AuthEvent {
  final String email;
  final String password;

  LodingEvent({required this.email, required this.password});
}
class RegisterEvent extends AuthEvent {
  final String email;
  final String password;

  RegisterEvent({required this.email, required this.password});
}
