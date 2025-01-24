import 'package:auto_route/auto_route.dart';
import 'package:lanars_test_task/app_router.gr.dart';

// Routs list
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page),
        AutoRoute(page: SignInRoute.page, initial: true),
      ];
}

class $AppRouter {}
