import 'package:cad_audio_service/ui/audio_store_wrapper.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:dependency_plugin/firebase_options.dart';
import 'package:efapp/manager/manager.dart';
import 'package:flutter/material.dart';
import 'package:efapp/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ///Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final DependencyManager dependencyManager = DependencyManager();
  await initDependencies(dependencyManager);

  EquatableConfig.stringify = true;

  runApp(const AudioStoreWrapper(child: RunnerApp()));
}

//initialize dependencies
Future<void> initDependencies(DependencyManager dependencyManager) async {
  await dependencyManager.init(nav: MCANavigation());
}
