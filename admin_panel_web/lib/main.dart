import 'package:admin_panel_web/manager/routes.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:dependency_plugin/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:admin_panel_web/app.dart';

///ADMIN PANEL WEB
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final DependencyManager dependencyManager = DependencyManager();
  await initDependencies(dependencyManager);

  Logger.init(true);

  EquatableConfig.stringify = true;

  runApp(const RunnerApp());
}

//initialize dependencies
Future<void> initDependencies(DependencyManager dependencyManager) async {
  await dependencyManager.init(nav: MCANavigation());
}
