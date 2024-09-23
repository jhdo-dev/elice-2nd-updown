import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// 각 페이지 import
// import 'home_view.dart';
// import 'chat_view.dart';
import 'package:up_down/src/view/result/result_view.dart';
import 'package:up_down/src/view/result/widgets/bottom_bar.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/result',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          // StatefulShellBranch(
          //   routes: [
          //     GoRoute(
          //       path: '/home',
          //       builder: (context, state) => const HomeView(),
          //     ),
          //   ],
          // ),

          // StatefulShellBranch(
          //   routes: [
          //     GoRoute(
          //       path: '/chat',
          //       builder: (context, state) => const ChatView(),
          //     ),
          //   ],
          // ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/result',
                builder: (context, state) => const ResultView(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
