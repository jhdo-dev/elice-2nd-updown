import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:up_down/component/page_not_found.dart';
import 'package:up_down/component/scaffold_with_nav_bar.dart';
import 'package:up_down/src/view/auth/auth_view.dart';
import 'package:up_down/src/view/auth/pages/sign_up_page.dart';
import 'package:up_down/util/router/route_names.dart';

part 'route_path.g.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter route(RouteRef ref) {
  return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/signin',
      routes: [
        GoRoute(
          path: '/auth',
          name: RouteNames.auth,
          builder: (context, state) {
            return const Placeholder();
          },
        ),
        GoRoute(
          path: '/signin',
          name: RouteNames.signin,
          builder: (context, state) {
            return const SignInPage();
          },
        ),
        GoRoute(
          path: '/signup',
          name: RouteNames.signup,
          builder: (context, state) {
            return const SignUpPage();
          },
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return ScaffoldWithNavBar(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/home',
                  name: RouteNames.home,
                  builder: (context, state) {
                    return const Placeholder();
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/chat',
                  name: RouteNames.chat,
                  builder: (context, state) {
                    return const Placeholder();
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/result',
                  name: RouteNames.result,
                  builder: (context, state) {
                    return const Placeholder();
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/setting',
                  name: RouteNames.setting,
                  builder: (context, state) {
                    return const Placeholder();
                  },
                ),
              ],
            ),
          ],
        ),
      ],
      errorBuilder: (context, state) =>
          PageNotFound(errMsg: state.error.toString()));
}
