import 'package:cad_audio_service/manager/middleware.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:just_audio/just_audio.dart';

final audioStore = Store<AudioState>(
  _reducer,
  middleware: [AudioMiddleware()],
  initialState: AudioState.initial(),
);

enum PlayButtonState {
  isPlaying,
  isPaused,
  isLoading,
}

@immutable
class AudioState {
  final AudioPlayer audioPlayer;
  final PlayButtonState playButtonState;

  const AudioState({
    required this.audioPlayer,
    required this.playButtonState,
  });

  factory AudioState.initial() {
    final player = AudioPlayer();

    return AudioState(
      audioPlayer: player,
      playButtonState: PlayButtonState.isPaused,
    );
  }

  AudioState copyWith({
    PlayButtonState? playButtonState,
  }) =>
      AudioState(
        audioPlayer: audioPlayer,
        playButtonState: playButtonState ?? this.playButtonState,
      );
}

class UpdateAudioStateAction {
  final PlayButtonState? playButtonState;
  const UpdateAudioStateAction({
    this.playButtonState,
  });
}

final _reducer = combineReducers<AudioState>([
  TypedReducer<AudioState, UpdateAudioStateAction>(_updateAudioState),
]);

AudioState _updateAudioState(AudioState state, UpdateAudioStateAction action) {
  return state.copyWith(
    playButtonState: action.playButtonState ?? state.playButtonState,
  );
}
