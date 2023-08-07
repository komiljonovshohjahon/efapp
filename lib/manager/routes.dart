import 'package:bot_toast/bot_toast.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:efapp/presentation/pages/pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:efapp/presentation/global_widgets/widgets.dart';
import 'package:efapp/utils/utils.dart';

class MCANavigation extends IMCANavigation {
  /// Global key for the navigator
  @override
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Route observer
  @override
  RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  // Routes
  static const String home = '/home';
  static const String blogs = '/blogs';
  static const String webView = '/webView';
  static const String yt = '/yt';
  static const String galleryAlbum = '/galleryAlbum';
  static const String pillarCloud = '/pillarCloud';
  static const String pillarFire = '/pillarFire';
  static const String loveOffering = '/loveOffering';
  static const String contactUs = '/contactUs';

  /// router
  @override
  late final router = GoRouter(
    debugLogDiagnostics: true,
    refreshListenable: loginState,
    navigatorKey: navigatorKey,
    initialLocation: home,
    observers: [BotToastNavigatorObserver()],
    routes: [
      ShellRoute(
          builder: (context, state, child) {
            return DefaultLayout(child: child);
          },
          routes: [
            GoRoute(
              path: home,
              name: home.substring(1),
              routes: [
                GoRoute(
                  path: blogs.substring(1),
                  name: blogs.substring(1),
                  routes: [
                    GoRoute(
                      path: ':id',
                      name: ':id',
                      pageBuilder: (context, state) {
                        final blog = state.extra as BlogMd;
                        return CustomTransitionPage<void>(
                          key: state.pageKey,
                          transitionsBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation,
                              Widget child) {
                            return Align(
                                child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ));
                          },
                          transitionDuration: const Duration(milliseconds: 400),
                          child: BlogDetailsView(blog: blog),
                        );
                      },
                    ),
                  ],
                  pageBuilder: (context, state) {
                    String? documentId;
                    final notificationPayload = state.extra;
                    if (notificationPayload != null &&
                        notificationPayload is Map<String, dynamic>) {
                      documentId = notificationPayload["documentId"];
                    }
                    return MaterialPage<void>(
                      key: state.pageKey,
                      child: BlogsView(documentId: documentId),
                    );
                  },
                ),
                GoRoute(
                  path: yt.substring(1),
                  name: yt.substring(1),
                  pageBuilder: (context, state) {
                    String? documentId;
                    final notificationPayload = state.extra;
                    if (notificationPayload != null &&
                        notificationPayload is Map<String, dynamic>) {
                      documentId = notificationPayload["documentId"];
                    }
                    return MaterialPage<void>(
                      key: state.pageKey,
                      child: YtVideoView(documentId: documentId),
                    );
                  },
                ),
                GoRoute(
                  path: webView.substring(1),
                  name: webView.substring(1),
                  pageBuilder: (context, state) {
                    final url = state.extra as String;
                    return MaterialPage<void>(
                      key: state.pageKey,
                      child: DefaultWebView(url: url),
                    );
                  },
                ),
                GoRoute(
                    path: galleryAlbum.substring(1),
                    name: galleryAlbum.substring(1),
                    pageBuilder: (context, state) {
                      String? documentId;
                      final notificationPayload = state.extra;
                      if (notificationPayload != null &&
                          notificationPayload is Map<String, dynamic>) {
                        documentId = notificationPayload["documentId"];
                      }
                      return MaterialPage<void>(
                        key: state.pageKey,
                        child:  GalleryAlbumView(galleryImageDocumentId: documentId),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'gallery/:id',
                        name: 'gallery/:id',
                        pageBuilder: (context, state) {
                          final model = state.extra as GalleryMd;
                          return MaterialPage<void>(
                            key: state.pageKey,
                            child: GalleryAlbumImagesView(model: model),
                          );
                        },
                      ),
                    ]),
                GoRoute(
                  path: pillarCloud.substring(1),
                  name: pillarCloud.substring(1),
                  pageBuilder: (context, state) {
                    return MaterialPage<void>(
                      key: state.pageKey,
                      child: PillarView(collection: FirestoreDep.pillarOfCloud),
                    );
                  },
                ),
                GoRoute(
                  path: pillarFire.substring(1),
                  name: pillarFire.substring(1),
                  pageBuilder: (context, state) {
                    return MaterialPage<void>(
                      key: state.pageKey,
                      child: PillarView(collection: FirestoreDep.pillarOfFire),
                    );
                  },
                ),
                GoRoute(
                  path: loveOffering.substring(1),
                  name: loveOffering.substring(1),
                  pageBuilder: (context, state) {
                    return MaterialPage<void>(
                      key: state.pageKey,
                      child: const LoveOfferingView(),
                    );
                  },
                ),
                GoRoute(
                  path: contactUs.substring(1),
                  name: contactUs.substring(1),
                  pageBuilder: (context, state) {
                    return MaterialPage<void>(
                      key: state.pageKey,
                      child: const ContactView(),
                    );
                  },
                ),
              ],
              pageBuilder: (context, state) {
                return MaterialPage<void>(
                  key: state.pageKey,
                  child: HomeView(),
                );
              },
            ),
          ]),
    ],
    errorPageBuilder: (context, state) => MaterialPage<void>(
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
              title: const Text('Delete file permanently?'),
              content: const Text(
                'If you delete this file, you won\'t be able to recover it. Do you want to delete it?',
              ),
              actions: [
                FilledButton(
                  child: const Text('Delete'),
                  onPressed: () {
                    context.pop(true);
                  },
                ),
                FilledButton(
                  child: const Text('Cancel'),
                  onPressed: () => context.pop(false),
                ),
              ],
            ));
  }

  @override
  void showSuccess(String msg) {
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
