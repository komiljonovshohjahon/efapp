import 'package:cad_audio_service/cad_audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class PlayButtonWidget extends StatelessWidget {
  const PlayButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AudioState, PlayButtonState>(
      converter: (store) => store.state.playButtonState,
      builder: (context, vm) {
        if (vm == PlayButtonState.isLoading) {
          return const CircularProgressIndicator();
        }
        return IconButton(
          icon: Icon(
            vm == PlayButtonState.isPlaying ? Icons.pause : Icons.play_arrow,
            size: 40,
          ),
          onPressed: () {
            if (vm == PlayButtonState.isPlaying) {
              // Pause
              StoreProvider.of<AudioState>(context)
                  .dispatch(const PauseAction());
            } else {
              // Play
              StoreProvider.of<AudioState>(context)
                  .dispatch(const PlayAction());
            }
          },
        );
      },
    );
  }
}
