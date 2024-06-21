import "package:flutter/material.dart";
import "package:get_it/get_it.dart";
import "package:go_router/go_router.dart";

import "../models/post_model.dart";
import "../screens/REST/post_details_screen.dart";
import "../screens/REST/rest_demo_screen.dart";

class GlobalRouter {
  // Static method to initialize the singleton in GetIt
  static void initialize() {
    GetIt.instance.registerSingleton<GlobalRouter>(GlobalRouter());
  }

  // Static getter to access the instance through GetIt
  static GlobalRouter get instance => GetIt.instance<GlobalRouter>();

  static GlobalRouter get I => GetIt.instance<GlobalRouter>();

  late GoRouter router;
  late GlobalKey<NavigatorState> _rootNavigatorKey;
  //late GlobalKey<NavigatorState> _shellNavigatorKey;

  GlobalRouter() {
    _rootNavigatorKey = GlobalKey<NavigatorState>();
    // _shellNavigatorKey = GlobalKey<NavigatorState>();

    router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: RestDemoScreen.route,
      routes: [
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: RestDemoScreen.route,
          name: RestDemoScreen.name,
          builder: (context, _) {
            return const RestDemoScreen();
          },
          routes: [
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: PostDetailsScreen.route,
              name: PostDetailsScreen.name,
              builder: (context, state) {
                final post = state.extra as Post;
                return PostDetailsScreen(post: post);
              },
            ),
          ],
        ),
      ],
    );
  }
}
