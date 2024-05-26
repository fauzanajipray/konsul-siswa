import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:konsul/features/article/presentations/article_page.dart';
import 'package:konsul/features/auth/bloc/auth_cubit.dart';
import 'package:konsul/features/auth/bloc/auth_state.dart';
import 'package:konsul/features/auth/bloc/login_cubit.dart';
import 'package:konsul/features/auth/presentations/sign_in_page.dart';
import 'package:konsul/features/auth/presentations/sign_up_page.dart';
import 'package:konsul/features/chat/presentations/chat_page.dart';
import 'package:konsul/features/dosen/bloc/mydosen_cubit.dart';
import 'package:konsul/features/dosen/presentations/dosen_page.dart';
import 'package:konsul/features/home/presentations/home_page.dart';
import 'package:konsul/features/profile/presentations/profile_page.dart';
import 'package:konsul/widgets/bottom_navigation_page.dart';

class AppRouter {
  static late final GoRouter _router;
  late final AuthCubit _authCubit;

  static final GlobalKey<NavigatorState> parentNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> tab1 = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> tab2 = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> tab3 = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> tab4 = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> tab5 = GlobalKey<NavigatorState>();
  AppRouter(this._authCubit) {
    final routes = [
      StatefulShellRoute.indexedStack(
        branches: [
          StatefulShellBranch(
            navigatorKey: tab1,
            routes: [
              GoRoute(
                path: Destination.homePath,
                pageBuilder: (context, GoRouterState state) {
                  return getPage(
                    child: const HomePage(),
                    state: state,
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: tab2,
            routes: [
              GoRoute(
                path: Destination.articlePath,
                pageBuilder: (context, GoRouterState state) {
                  return getPage(
                    child: const ArticlePage(),
                    state: state,
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: tab3,
            routes: [
              GoRoute(
                path: Destination.dosenPath,
                pageBuilder: (context, state) {
                  return getPage(
                    child: BlocProvider<MydosenCubit>(
                      create: (context) => MydosenCubit(),
                      child: const DosenPage(),
                    ),
                    state: state,
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: tab4,
            routes: [
              GoRoute(
                path: Destination.chatPath,
                pageBuilder: (context, state) {
                  return getPage(
                    child: const ChatPage(),
                    state: state,
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: tab5,
            routes: [
              GoRoute(
                path: Destination.profilePath,
                pageBuilder: (context, state) {
                  return getPage(
                    child: const ProfilePage(),
                    state: state,
                  );
                },
              ),
            ],
          ),
        ],
        pageBuilder: (
          BuildContext context,
          GoRouterState state,
          StatefulNavigationShell navigationShell,
        ) {
          return getPage(
            child: BottomNavigationPage(
              child: navigationShell,
            ),
            state: state,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: parentNavigatorKey,
        path: Destination.signInPath,
        pageBuilder: (context, state) {
          return getPage(
            child: const SignInPage(),
            state: state,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: parentNavigatorKey,
        path: Destination.signUpPath,
        pageBuilder: (context, state) {
          return getPage(
            child: const SignUpPage(),
            state: state,
          );
        },
      ),
    ];

    _router = GoRouter(
      navigatorKey: parentNavigatorKey,
      initialLocation: Destination.homePath,
      refreshListenable: GoRouterRefreshStream(_authCubit.stream),
      routes: routes,
      redirect: (context, state) {
        final bool isAuthenticated =
            _authCubit.state.status == AuthStatus.authenticated &&
                _authCubit.state.userId != "" &&
                _authCubit.state.name != "";

        final bool isUnauthenticated =
            _authCubit.state.status == AuthStatus.unauthenticated ||
                _authCubit.state.userId == "" ||
                _authCubit.state.name == "";

        const nonAuthRoutes = [
          Destination.signInPath,
          Destination.signUpPath,
          // '/forgot-password'
        ];

        // setelah main url, sub urlnya apa
        String? subloc = state.fullPath;

        // params from
        String fromRoutes = state.pathParameters['from'] ?? '';

        // print("${_authCubit.state.status} - isAuthenticated : $isAuthenticated , isUnauthenticated : $isUnauthenticated ");

        // jika akses /login tapi ternyata sudah authenticated
        if (nonAuthRoutes.contains(subloc) && isAuthenticated) {
          // ini ngembaliin ke halaman yang diinginkan setelah login
          if (fromRoutes.isNotEmpty) {
            return fromRoutes;
          }
          return Destination.homePath;
        } else if (!nonAuthRoutes.contains(subloc) && isUnauthenticated) {
          return Destination.signInPath;
        }
        return null;
      },
    );
  }

  static Page getPage({
    required Widget child,
    required GoRouterState state,
  }) {
    return MaterialPage(
      key: state.pageKey,
      child: child,
    );
  }

  GoRouter get router => _router;
}

class Destination {
  static const String signInPath = '/signIn';
  static const String signUpPath = '/signUp';

  static const String homePath = '/home';
  static const String articlePath = '/article';
  static const String addArticlePath = '/add-article';
  static const String dosenPath = '/dosen';
  static const String chatPath = '/chat';
  static const String profilePath = '/profile';
}

class GoRouterRefreshStream extends ChangeNotifier {
  /// Creates a [GoRouterRefreshStream].
  ///
  /// Every time the [stream] receives an event the [GoRouter] will refresh its
  /// current route.
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
