import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'UI/sign_in_screen/bloc/sign_in_bloc.dart';
import 'app_router.dart';
import 'theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInBloc(),
      child: MaterialApp.router(
        theme: lightTheme,
        routerConfig: _appRouter
            .config(), // Route configuration in the app (SignInScreen - Intital)
      ),
    );
  }
}
