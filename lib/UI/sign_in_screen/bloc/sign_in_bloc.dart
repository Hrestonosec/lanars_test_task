import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final Dio dio = Dio(); // Create an instance of Dio for making API requests

  SignInBloc() : super(SignInInitial()) {
    on<EmailChanged>((event, emit) {
      if (state is SignInLoading) return; // Prevent changes while loading

      // Validate email format
      if (isValidEmail(event.email)) {
        emit(EmailValid());
      } else {
        emit(EmailInvalid());
      }
    });

    on<PasswordChanged>((event, emit) {
      if (state is SignInLoading) return; // Prevent changes while loading

      // Validate password format
      if (isValidPassword(event.password)) {
        emit(PasswordValid());
      } else {
        emit(PasswordInvalid());
      }
    });

    on<SignInSubmitted>((event, emit) async {
      final isEmailValid = isValidEmail(event.email); // Check if email is valid
      final isPasswordValid =
          isValidPassword(event.password); // Check if password is valid

      emit(SignInLoading()); // Emit loading state before attempting sign-in

      if (!isEmailValid || !isPasswordValid) {
        // If either email or password is invalid, emit failure state
        final error = (!isEmailValid && !isPasswordValid)
            ? "Invalid email and password format" // Both invalid
            : !isEmailValid
                ? "Invalid email format" // Only email invalid
                : "Invalid password format"; // Only password invalid
        emit(SignInFailure(error: error));
        return;
      }

      try {
        await Future.delayed(
            const Duration(seconds: 1)); // Simulate network delay

        // Attempt to fetch user data from the mock API
        final response = await dio.get('https://randomuser.me/api/');
        final userData =
            response.data['results'][0]; // Extract user data from response
        emit(SignInSuccess(
            userData: userData)); // Emit success state with user data
      } catch (e) {
        emit(SignInFailure(error: 'Something went wrong. Please try again.'));
      }
    });

    on<ResetEmailError>((event, emit) => emit(EmailResetError()));

    on<ResetPasswordError>((event, emit) => emit(PasswordResetError()));
  }

  // Regular expression for validating email format
  final emailRegExp = RegExp(
      r"^[a-zA-Z0-9.!#$%&\'*+\\/=?^_`{|}~-]{1,10}@(?:(?!.*--)[a-zA-Z0-9-]{1,10}(?<!-))(?:\.(?:[a-zA-Z0-9-]{2,10}))+$");

  // Regular expression for validating password format (must contain letters and digits)
  final passwordRegExp =
      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,10}$');

  // Function to validate email format using regular expression
  bool isValidEmail(String email) {
    return email.length >= 6 &&
        email.length <= 30 && // Ensure email is within valid length
        emailRegExp.hasMatch(email); // Check if email matches the regex
  }

  // Function to validate password format using regular expression
  bool isValidPassword(String password) {
    return password.length >= 6 &&
        password.length <= 10 && // Ensure password is within valid length
        passwordRegExp
            .hasMatch(password); // Check if password matches the regex
  }
}
