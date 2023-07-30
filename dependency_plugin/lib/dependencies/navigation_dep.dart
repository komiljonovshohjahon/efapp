import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class IMCANavigation {
  final MCALoginState loginState = MCALoginState();

  GlobalKey<NavigatorState> get navigatorKey;

  RouteObserver<PageRoute> get routeObserver;

  GoRouter get router;

  //Loading related functions
  void Function() showLoading(
      {bool barrierDismissible = false, bool showCancelButton = false});

  void closeLoading();

  Future<T> futureLoading<T>(Future<T> Function() future);

  void showSuccess(String msg);

  void showFail(String msg);

  Future<bool?> showAlert(BuildContext context);

  Future<T?> showCustomDialog<T>(
      {required BuildContext context,
      required WidgetBuilder builder,
      bool barrierDismissible = false});
}

class MCALoginState extends ChangeNotifier {
  ///Do not use this class directly, use [DependencyManager.instance.navigation.loginState] instead
  ///
  /// Do not use [DependencyManager.instance] inside this class
  MCALoginState() {
    init();
  }

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<Either<String, bool>> login(String email, String pwd) async {
    try {
      final success = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pwd);
      if (success.user != null) {
        if (_isLoggedIn) return const Right(true);
        Logger.i("Login success for $email");
      } else {
        // _isLoggedIn = false;
        // notifyListeners();
        Logger.e("Login failed for $email");
      }
      return Right(success.user != null);
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? e.toString());
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<void> logout() async {
    if (!_isLoggedIn) return;
    try {
      await FirebaseAuth.instance.signOut();
      Logger.e("Logout success");
    } on FirebaseAuthException catch (e) {
      Logger.e(e);
    } catch (e) {
      Logger.e(e);
    }
  }

  Future<Either<String, bool>> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Logger.i("Password reset for $email");
      return const Right(true);
    } on FirebaseAuthException catch (e) {
      Logger.e(e);
      return Left(e.message ?? e.toString());
    } catch (e) {
      Logger.e(e);
      return Left(e.toString());
    }
  }

  Future<void> init() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        _isLoggedIn = false;
        notifyListeners();
        debugPrint('User is currently signed out!');
      } else {
        _isLoggedIn = true;
        notifyListeners();
        debugPrint('User is signed in!');
      }
    });
  }
}
