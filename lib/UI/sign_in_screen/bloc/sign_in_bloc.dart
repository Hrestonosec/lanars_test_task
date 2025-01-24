import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final Dio dio = Dio();

  SignInBloc() : super(SignInInitial()) {
    on<EmailChanged>((event, emit) {
      if (state is SignInLoading) return;

      if (isValidEmail(event.email)) {
        emit(EmailValid());
      } else {
        emit(EmailInvalid());
      }
    });

    on<PasswordChanged>((event, emit) {
      if (state is SignInLoading) return;

      if (isValidPassword(event.password)) {
        emit(PasswordValid());
      } else {
        emit(PasswordInvalid());
      }
    });

    on<SignInSubmitted>((event, emit) async {
      final isEmailValid = isValidEmail(event.email);
      final isPasswordValid = isValidPassword(event.password);

      emit(SignInLoading());

      if (!isEmailValid || !isPasswordValid) {
        final error = (!isEmailValid && !isPasswordValid)
            ? "Invalid email and password format"
            : !isEmailValid
                ? "Invalid email format"
                : "Invalid password format";
        emit(SignInFailure(error: error));
        return;
      }

      try {
        await Future.delayed(const Duration(seconds: 1));

        final response = await dio.get('https://randomuser.me/api/');
        final userData = response.data['results'][0];
        emit(SignInSuccess(userData: userData));
      } catch (e) {
        emit(SignInFailure(error: 'Something went wrong. Please try again.'));
      }
    });

    on<ResetEmailError>((event, emit) => emit(EmailResetError()));
    on<ResetPasswordError>((event, emit) => emit(PasswordResetError()));
  }

  final emailRegExp = RegExp(
      r"^[a-zA-Z0-9.!#$%&\'*+\\/=?^_`{|}~-]{1,10}@(?:(?!.*--)[a-zA-Z0-9-]{1,10}(?<!-))(?:\.(?:[a-zA-Z0-9-]{2,10}))+$");

  final passwordRegExp =
      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,10}$');

  bool isValidEmail(String email) {
    return email.length >= 6 &&
        email.length <= 30 &&
        emailRegExp.hasMatch(email);
  }

  bool isValidPassword(String password) {
    return password.length >= 6 &&
        password.length <= 10 &&
        passwordRegExp.hasMatch(password);
  }
}
