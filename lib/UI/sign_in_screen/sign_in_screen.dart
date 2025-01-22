import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lanars_test_task/UI/users_list_screen/users_list_screen.dart';

import 'bloc/sign_in_bloc.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return BlocProvider(
      create: (context) => SignInBloc(),
      child: Scaffold(
        body: BlocConsumer<SignInBloc, SignInState>(
          listener: (context, state) {
            if (state is SignInSuccess) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UsersListScreen(userData: state.userData),
                  ),
                );
              });
            } else if (state is SignInFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                  state.error,
                  style: TextStyle(color: Colors.red),
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
                      onChanged: (value) {
                        context
                            .read<SignInBloc>()
                            .add(EmailChanged(email: value));
                      },
                      maxLength: 30,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        errorText: state is EmailInvalid
                            ? 'Invalid email format'
                            : null,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      controller: passwordController,
                      onChanged: (value) {
                        context
                            .read<SignInBloc>()
                            .add(PasswordChanged(password: value));
                      },
                      obscureText: true,
                      maxLength: 10,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        errorText: state is PasswordInvalid
                            ? 'Invalid password format'
                            : null,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: passwordController.text.isEmpty ||
                              emailController.text.isEmpty ||
                              state is EmailInvalid ||
                              state is PasswordInvalid ||
                              state is SignInLoading
                          ? null
                          : () {
                              context.read<SignInBloc>().add(SignInSubmitted(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  ));
                            },
                      child: state is SignInLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Log In'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
