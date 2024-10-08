import 'dart:io';

import 'package:chat/features/auth/presentation/login_screen.dart';
import 'package:chat/features/chat/presentation/chat/chat_screen.dart';
import 'package:chat/features/chat/presentation/inbox/inbox_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:chat/config/routes/routes.dart';
import 'package:chat/features/profile/presentation/profiles_screen.dart';
import 'package:chat/features/main/presentation/pages/main_screen.dart';
import 'package:chat/features/main/presentation/pages/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final AppRouter _instance = AppRouter._internal();
  static AppRouter get instance => _instance;
  factory AppRouter() {
    return _instance;
  }

  static late final GoRouter router;

  BuildContext get context => router.routerDelegate.navigatorKey.currentContext!;

  GoRouterDelegate get routerDelegate => router.routerDelegate;

  GoRouteInformationParser get routeInformationParser => router.routeInformationParser;

  static final parentNavigatorKey = GlobalKey<NavigatorState>();
  static final profilesTabNavigatorKey = GlobalKey<NavigatorState>();
  static final inboxTabNavigatorKey = GlobalKey<NavigatorState>();

  AppRouter._internal() {
    final routes = [
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: parentNavigatorKey,
        branches: [
          StatefulShellBranch(
            navigatorKey: profilesTabNavigatorKey,
            routes: [
              getGoRouteInstance(route: Routes.profiles, child: const ProfilesScreen()),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: inboxTabNavigatorKey,
            routes: [
              getGoRouteInstance(route: Routes.inbox, child: const InboxScreen()),
            ],
          ),
        ],
        pageBuilder: (context, state, navigationShell) =>
            getPage(state: state, child: MainScreen(child: navigationShell)),
      ),

      getGoRouteInstance(
        parentNavigatorKey: parentNavigatorKey,
        route: Routes.splash,
        child: const SplashScreen(),
      ),

      // Login
      getGoRouteInstance(
        parentNavigatorKey: parentNavigatorKey,
        route: Routes.login,
        child: const LoginScreen(),
      ),
      // Chat
      getGoRouteInstance(
        parentNavigatorKey: parentNavigatorKey,
        route: Routes.chat,
        pageBuilder: (context, state) {
          return getPage(
            state: state,
            child: ChatScreen(chatId: state.uri.queryParameters['chatId']!),
          );
        },
      ),
    ];
    router = GoRouter(
      navigatorKey: parentNavigatorKey,
      debugLogDiagnostics: true,
      initialLocation: Routes.splash.path,
      routes: routes,
    );
  }

  static GoRoute getGoRouteInstance({
    GlobalKey<NavigatorState>? parentNavigatorKey,
    required Routes route,
    Page<dynamic> Function(BuildContext, GoRouterState)? pageBuilder,
    Widget? child,
    List<RouteBase> routes = const <RouteBase>[],
  }) {
    assert(pageBuilder != null || child != null, 'pageBuilder, or child must be provided');
    return GoRoute(
      parentNavigatorKey: parentNavigatorKey,
      name: route.name,
      path: route.path,
      pageBuilder: pageBuilder ?? (context, state) => getPage(state: state, child: child!),
      routes: routes,
    );
  }

  static Page getPage({required Widget child, required GoRouterState state}) => Platform.isIOS
      ? CupertinoPage(key: state.pageKey, child: child)
      : MaterialPage(key: state.pageKey, child: child);
}
