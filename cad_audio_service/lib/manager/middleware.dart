import 'package:cad_audio_service/cad_audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:redux/redux.dart';

class AudioMiddleware extends MiddlewareClass<AudioState> {
  @override
  call(Store<AudioState> store, action, NextDispatcher next) {
    switch (action.runtimeType) {
      case PlayFromUrlAction:
        return _playFromUrl(store, action, next);
      case PauseAction:
        return _pause(store, action, next);
      case PlayAction:
        return _play(store, action, next);
    }
  }

  void _listenPlayButtonState(AudioPlayer player, NextDispatcher next) {
    player.playerStateStream.listen((event) {
      debugPrint("playerStateStream: $event");
      if (event.processingState == ProcessingState.loading ||
          event.processingState == ProcessingState.buffering) {
        next(const UpdateAudioStateAction(
            playButtonState: PlayButtonState.isLoading));
        return;
      }
      if (event.processingState == ProcessingState.completed) {
        next(const UpdateAudioStateAction(
            playButtonState: PlayButtonState.isPaused));
        return;
      }
      if (event.playing) {
        next(const UpdateAudioStateAction(
            playButtonState: PlayButtonState.isPlaying));
        return;
      }
      next(const UpdateAudioStateAction(
          playButtonState: PlayButtonState.isPaused));
    });
  }

  Future<void> _playFromUrl(Store<AudioState> store, PlayFromUrlAction action,
      NextDispatcher next) async {
    final url = action.url;
    final player = store.state.audioPlayer;

    try {
      _listenPlayButtonState(player, next);
      final Duration? duration = await player.setUrl(url);
      if (duration != null) {
        player.play();
        return;
      }
      throw Exception("Error playing $url");
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //pause
  Future<void> _pause(
      Store<AudioState> store, PauseAction action, NextDispatcher next) async {
    try {
      final player = store.state.audioPlayer;
      _listenPlayButtonState(player, next);
      player.pause();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //play
  Future<void> _play(
      Store<AudioState> store, PlayAction action, NextDispatcher next) async {
    try {
      final player = store.state.audioPlayer;
      _listenPlayButtonState(player, next);
      await player.play();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
