part of 'sign_in_bloc.dart';

abstract class SignInState {}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class EmailValid extends SignInState {}

class EmailInvalid extends SignInState {}

class PasswordValid extends SignInState {}

class PasswordInvalid extends SignInState {}

class SignInSuccess extends SignInState {
  final Map<String, dynamic> userData;

  SignInSuccess({required this.userData});
}

class SignInFailure extends SignInState {
  final String error;

  SignInFailure({required this.error});
}
