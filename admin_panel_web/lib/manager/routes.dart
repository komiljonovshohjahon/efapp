import 'package:bot_toast/bot_toast.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:admin_panel_web/presentation/global_widgets/widgets.dart';
import 'package:admin_panel_web/presentation/pages/pages.dart';
import 'package:admin_panel_web/utils/utils.dart';

class MCANavigation extends IMCANavigation {
  /// Global key for the navigator
  @override
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Route observer
  @override
  RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  // Routes
  ///Root is where we check if the user is logged in or not
  static const String root = '/root';

  ///Login is where the user logs in
  static const String login = '/login';

  /// router
  @override
  late final router = GoRouter(
    // debugLogDiagnostics: true,
    refreshListenable: loginState,
    navigatorKey: navigatorKey,
    observers: [BotToastNavigatorObserver()],
    routes: [
      GoRoute(
        path: "/",
        name: "root",
        redirect: (state, context) => login,
      ),
      GoRoute(
        path: login,
        name: login.substring(1),
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: const LoginView(),
          );
        },
      ),
      ShellRoute(
          builder: (context, state, child) {
            return DefaultLayout(child: child);
          },
          routes: [
            GoRoute(
              path: adminDestinations['books']!['route']!,
              name: adminDestinations['books']!['route']!.substring(1),
              pageBuilder: (context, state) {
                return NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const BooksView(),
                );
              },
            ),
            GoRoute(
              path: adminDestinations['blogs']!['route']!,
              name: adminDestinations['blogs']!['route']!.substring(1),
              pageBuilder: (context, state) {
                return NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const BLogsView(),
                );
              },
            ),
            GoRoute(
              path: adminDestinations['videos']!['route']!,
              name: adminDestinations['videos']!['route']!.substring(1),
              pageBuilder: (context, state) {
                return NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const YtView(),
                );
              },
            ),
            GoRoute(
              path: adminDestinations['fireForms']!['route']!,
              name: adminDestinations['fireForms']!['route']!.substring(1),
              pageBuilder: (context, state) {
                return NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const PillarOfFireFormsView(),
                );
              },
            ),
          ]),
    ],
    errorPageBuilder: (context, state) => NoTransitionPage<void>(
      key: state.pageKey,
      child: Scaffold(
          body: Center(
        child: Text(
          'Page not found: ${state.path}\n'
          'This is the default error page.\n',
          style: const TextStyle(fontSize: 24),
        ),
      )),
    ),
    redirect: (context, state) {
      if (state.name == 'root') return null;
      final loginLoc = state.namedLocation(login.substring(1));
      final homename = state
          .namedLocation(adminDestinations["books"]!['route']!.substring(1));

      final loggedIn = loginState.isLoggedIn;

      final loggingIn = state.location == loginLoc;

      if (!loggedIn && !loggingIn) return loginLoc;
      if (loggedIn && loggingIn) return homename;
      return null;
    },
  );

  //Loading related functions
  @override
  CancelFunc showLoading(
      {bool barrierDismissible = false, bool showCancelButton = false}) {
    return BotToast.showCustomLoading(
      toastBuilder: (cancelFunc) {
        return AppLoadingWidget(
            onClose: kDebugMode
                ? cancelFunc
                : showCancelButton
                    ? cancelFunc
                    : null);
      },
      clickClose: barrierDismissible,
      allowClick: false,
      backButtonBehavior: BackButtonBehavior.ignore,
    );
  }

  @override
  void closeLoading() {
    BotToast.closeAllLoading();
  }

  @override
  Future<T> futureLoading<T>(Future<T> Function() future) async {
    if (GlobalConstants.enableLoadingIndicator) {
      CancelFunc cancel = showLoading();
      T result = await future();
      cancel();
      return result;
    } else {
      T result = await future();
      return result;
    }
  }

  @override
  Future<bool?> showAlert(BuildContext context) async {
    return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Delete?'),
              content: const Text('Do you want to delete?'),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                ElevatedButton(
                  child: const Text('Cancel'),
                  onPressed: () => context.pop(false),
                ),
                FilledButton(
                  child: const Text('Delete'),
                  onPressed: () {
                    context.pop(true);
                  },
                ),
              ],
            ));
  }

  @override
  void showSuccess(String msg) {
    CancelFunc cancel = BotToast.showCustomText(
      duration: const Duration(seconds: 4),
      wrapToastAnimation: (controller, cancelFunc, widget) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                cancelFunc();
              },
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: controller.value,
                    child: child,
                  );
                },
                child: const SizedBox.expand(),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: controller,
                  curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
                ),
                child: widget,
              ),
            ),
          ],
        );
      },
      toastBuilder: (cancelFunc) {
        return Container(
            decoration: const BoxDecoration(
              color: Colors.black38,
            ),
            child: AlertDialog(
              icon: const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
              ),
              title: const Text('Success'),
              actions: [
                ElevatedButton(
                  onPressed: cancelFunc,
                  child: const Text('Close'),
                ),
              ],
              content: Text(msg),
              contentTextStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ));
      },
    );
  }

  @override
  void showFail(String msg, {VoidCallback? onClose}) {
    CancelFunc cancel = BotToast.showCustomText(
      duration: null,
      wrapToastAnimation: (controller, cancelFunc, widget) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                cancelFunc();
              },
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: controller.value,
                    child: child,
                  );
                },
                child: const SizedBox.expand(),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: controller,
                  curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
                ),
                child: widget,
              ),
            ),
          ],
        );
      },
      toastBuilder: (cancelFunc) {
        return Container(
            decoration: const BoxDecoration(
              color: Colors.black38,
            ),
            child: AlertDialog(
              icon: const Icon(
                Icons.error_outline,
                color: Colors.red,
              ),
              title: const Text('Error'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    cancelFunc();
                    onClose?.call();
                  },
                  child: const Text('Close'),
                ),
              ],
              content: Text(msg, textAlign: TextAlign.center),
              contentTextStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ));
      },
    );
  }

  @override
  Future<T?> showCustomDialog<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool barrierDismissible = false,
  }) async {
    return await showDialog<T>(
      barrierDismissible: kDebugMode ? true : barrierDismissible,
      context: context,
      builder: builder,
    );
  }
}
