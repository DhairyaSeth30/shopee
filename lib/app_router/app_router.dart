
import 'package:go_router/go_router.dart';
import 'package:shopee/app_router/route_constants.dart';

import '../screens/home_page.dart';
import '../screens/login_page.dart';
import '../screens/splash_screen.dart';


final router = GoRouter(
  // initialLocation: Routes.home,
  initialLocation: '/${Routes.splash}',
  routes: [
    GoRoute(
      name: Routes.splash,
      path: '/${Routes.splash}',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      name: Routes.home,
      path: Routes.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      name: Routes.signIn,
      path: '/${Routes.signIn}',
      builder: (context, state) => const SignInScreen(),
    ),

  ],
);