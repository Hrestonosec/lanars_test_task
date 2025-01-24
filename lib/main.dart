import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'UI/sign_in_screen/bloc/sign_in_bloc.dart';
import 'UI/sign_in_screen/sign_in_screen.dart';
import 'theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      // Defines the initial route when the app starts
      initialRoute: '/login',
      // Defines the routes for navigation within the app
      routes: {
        '/login': (context) => BlocProvider(
            create: (context) => SignInBloc(), child: SignInScreen()),
      },
    );
  }
}
