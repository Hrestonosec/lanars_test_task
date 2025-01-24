import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lanars_test_task/UI/home_screen/home_screen.dart';

import 'bloc/sign_in_bloc.dart';

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

  @override
  void initState() {
    super.initState();
    emailFocusNode.addListener(_onFocusChangeEmail);
    passwordFocusNode.addListener(_onFocusChangePassword);
  }

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

  void _onFocusChangeEmail() {
    if (!emailFocusNode.hasFocus) {
      // Перевірка валідації для email після втрати фокусу
      context.read<SignInBloc>().add(EmailChanged(email: emailController.text));
    }
  }

  void _onFocusChangePassword() {
    if (!passwordFocusNode.hasFocus) {
      // Перевірка валідації для паролю після втрати фокусу
      context
          .read<SignInBloc>()
          .add(PasswordChanged(password: passwordController.text));
    }
  }

  String? _getEmailError(SignInState state) {
    if (state is EmailInvalid) {
      return 'Invalid email format';
    } else if (state is EmailResetError) {
      return null;
    }
    return null; // За замовчуванням без помилок
  }

  String? _getPasswordError(SignInState state) {
    if (state is PasswordInvalid) {
      return 'Invalid password format';
    } else if (state is PasswordResetError) {
      return null;
    }
    return null; // За замовчуванням без помилок
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SignInBloc, SignInState>(
        listener: (context, state) {
          if (state is SignInSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(userData: state.userData),
                ),
              );
            });
          } else if (state is SignInFailure) {
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
                Container(
                    padding: EdgeInsets.fromLTRB(20, 100, 20, 20),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(fontSize: 30),
                    )),
                Container(
                  padding: EdgeInsets.all(20),
                  child: TextField(
                    controller: emailController,
                    focusNode: emailFocusNode,
                    onChanged: (_) {
                      context.read<SignInBloc>().add(ResetEmailError());
                    },
                    enabled: state is! SignInLoading || state is! SignInSuccess,
                    maxLength: 30,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      errorText: _getEmailError(state),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: TextField(
                    controller: passwordController,
                    focusNode: passwordFocusNode,
                    onChanged: (_) {
                      context.read<SignInBloc>().add(ResetPasswordError());
                    },
                    enabled: state is! SignInLoading || state is! SignInSuccess,
                    obscureText: true,
                    maxLength: 10,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        errorText: _getPasswordError(state)),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state is SignInLoading || state is SignInSuccess
                        ? null // Блокуємо кнопку під час завантаження
                        : () {
                            if (emailController.text.isEmpty ||
                                passwordController.text.isEmpty ||
                                state is EmailInvalid ||
                                state is PasswordInvalid) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Будь ласка, заповніть коректно всі поля'),
                                ),
                              );
                              return;
                            }
                            context.read<SignInBloc>().add(SignInSubmitted(
                                  email: emailController.text,
                                  password: passwordController.text,
                                ));
                          },
                    child: state is SignInLoading || state is SignInSuccess
                        ? const CircularProgressIndicator()
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
