import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lanars_test_task/app_router.gr.dart';

import 'bloc/sign_in_bloc.dart';

@RoutePage()
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  // Initialize focus listeners
  @override
  void initState() {
    super.initState();
    emailFocusNode.addListener(_onFocusChangeEmail);
    passwordFocusNode.addListener(_onFocusChangePassword);
  }

  // Dispose of controllers and focus nodes when the widget is disposed
  @override
  void dispose() {
    emailFocusNode.removeListener(_onFocusChangeEmail);
    passwordFocusNode.removeListener(_onFocusChangePassword);
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  // Called when the email field loses focus, triggering validation
  void _onFocusChangeEmail() {
    if (!emailFocusNode.hasFocus) {
      context.read<SignInBloc>().add(EmailChanged(email: emailController.text));
    }
  }

  // Called when the password field loses focus, triggering validation
  void _onFocusChangePassword() {
    if (!passwordFocusNode.hasFocus) {
      context
          .read<SignInBloc>()
          .add(PasswordChanged(password: passwordController.text));
    }
  }

  // Helper function to get the error text for the email field
  String? _getEmailError(SignInState state) {
    if (state is EmailInvalid) {
      return 'Invalid email format'; // Show error message for invalid email
    } else if (state is EmailResetError) {
      return null; // No error when user editing email or password
    }
    return null; // No error by default
  }

  // Helper function to get the error text for the password field
  String? _getPasswordError(SignInState state) {
    if (state is PasswordInvalid) {
      return 'Invalid password format'; // Show error message for invalid password
    } else if (state is PasswordResetError) {
      return null; // No error when user editing email or password
    }
    return null; // No error by default
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SignInBloc, SignInState>(
        listener: (context, state) {
          if (state is SignInSuccess) {
            // Navigate to the HomeScreen if sign-in is successful
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.router.push(HomeRoute(userData: state.userData));
            });
          } else if (state is SignInFailure) {
            // Show an error message if sign-in failed
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                state.error,
              )),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // Title of the screen
                Container(
                    padding: EdgeInsets.fromLTRB(20, 100, 20, 20),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(fontSize: 30),
                    )),
                // Email input field
                Container(
                  padding: EdgeInsets.all(20),
                  child: TextField(
                    controller: emailController,
                    focusNode: emailFocusNode,
                    onChanged: (_) {
                      context.read<SignInBloc>().add(ResetEmailError());
                    },
                    // Disable input if loading or already signed in
                    enabled: state is SignInLoading || state is SignInSuccess
                        ? false
                        : true,
                    maxLength: 30,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      errorText:
                          _getEmailError(state), // Show email error if present
                    ),
                  ),
                ),
                // Password input field
                Container(
                  padding: EdgeInsets.all(20),
                  child: TextField(
                    controller: passwordController,
                    focusNode: passwordFocusNode,
                    onChanged: (_) {
                      context.read<SignInBloc>().add(ResetPasswordError());
                    },
                    // Disable input if loading or already signed in
                    enabled: state is SignInLoading || state is SignInSuccess
                        ? false
                        : true,
                    obscureText: true,
                    maxLength: 10,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        errorText: _getPasswordError(
                            state)), // Show password error if present
                  ),
                ),
                // Log in button
                Container(
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state is SignInLoading || state is SignInSuccess
                        ? null // Disable button if loading or already signed in
                        : () {
                            // Check if fields are empty or invalid before submitting
                            if (emailController.text.isEmpty ||
                                passwordController.text.isEmpty ||
                                state is EmailInvalid ||
                                state is PasswordInvalid) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Please fill in all fields correctly.'),
                                ),
                              );
                              return;
                            }
                            // Submit sign-in event if all fields are valid
                            context.read<SignInBloc>().add(SignInSubmitted(
                                  email: emailController.text,
                                  password: passwordController.text,
                                ));
                          },
                    child: state is SignInLoading || state is SignInSuccess
                        ? const CircularProgressIndicator() // Show loading indicator while signing in
                        : const Text('Log In'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
