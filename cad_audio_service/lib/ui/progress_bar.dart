import 'package:cad_audio_service/cad_audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ProgressBarWidget extends StatelessWidget {
  const ProgressBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AudioState, AudioState>(
      converter: (store) => store.state,
      builder: (context, vm) {
        return const SizedBox(
          height: 10,
          child: LinearProgressIndicator(
            value: 0.5,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            backgroundColor: Colors.grey,
          ),
        );
      },
    );
  }
}
