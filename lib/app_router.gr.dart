// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i3;
import 'package:flutter/material.dart' as _i4;
import 'package:lanars_test_task/UI/home_screen/home_screen.dart' as _i1;
import 'package:lanars_test_task/UI/sign_in_screen/sign_in_screen.dart' as _i2;

/// generated route for
/// [_i1.HomeScreen]
class HomeRoute extends _i3.PageRouteInfo<HomeRouteArgs> {
  HomeRoute({
    _i4.Key? key,
    required Map<String, dynamic> userData,
    List<_i3.PageRouteInfo>? children,
  }) : super(
         HomeRoute.name,
         args: HomeRouteArgs(key: key, userData: userData),
         initialChildren: children,
       );

  static const String name = 'HomeRoute';

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<HomeRouteArgs>();
      return _i1.HomeScreen(key: args.key, userData: args.userData);
    },
  );
}

class HomeRouteArgs {
  const HomeRouteArgs({this.key, required this.userData});

  final _i4.Key? key;

  final Map<String, dynamic> userData;

  @override
  String toString() {
    return 'HomeRouteArgs{key: $key, userData: $userData}';
  }
}

/// generated route for
/// [_i2.SignInScreen]
class SignInRoute extends _i3.PageRouteInfo<void> {
  const SignInRoute({List<_i3.PageRouteInfo>? children})
    : super(SignInRoute.name, initialChildren: children);

  static const String name = 'SignInRoute';

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      return const _i2.SignInScreen();
    },
  );
}
