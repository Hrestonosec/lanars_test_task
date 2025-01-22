part of 'sign_in_bloc.dart';

abstract class SignInEvent {}

class EmailChanged extends SignInEvent {
  final String email;
  EmailChanged({required this.email});
}

class PasswordChanged extends SignInEvent {
  final String password;
  PasswordChanged({required this.password});
}

class SignInSubmitted extends SignInEvent {
  final String email;
  final String password;

  SignInSubmitted({required this.email, required this.password});
}
