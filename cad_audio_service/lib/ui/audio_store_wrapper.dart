import 'package:cad_audio_service/manager/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class AudioStoreWrapper extends StatelessWidget {
  final Widget child;
  const AudioStoreWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(store: audioStore, child: child);
  }
}
