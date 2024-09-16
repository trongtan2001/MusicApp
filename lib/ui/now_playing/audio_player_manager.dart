import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/model/song.dart';

class AudioPlayerManager {
  AudioPlayerManager._internal();

  static final AudioPlayerManager _instance = AudioPlayerManager._internal();

  factory AudioPlayerManager() => _instance;

  final player = AudioPlayer();
  Stream<DurationState>? durationState;
  String songUrl = "";

  final ValueNotifier<Song?> currentSongNotifier = ValueNotifier(null);

  void playSong(Song song) {
    if(currentSongNotifier.value?.id == song.id){
      return ;
    }
    currentSongNotifier.value = song;
    player.setUrl(song.source).then((_) {
      player.play();
    }).catchError((error) {
    });
  }

  void prepare({bool isNewSong = false}) {
    durationState = Rx.combineLatest2<Duration, PlaybackEvent, DurationState>(
        player.positionStream,
        player.playbackEventStream,
        (position, playbackEvent) => DurationState(
            progress: position,
            buffered: playbackEvent.bufferedPosition,
            total: playbackEvent.duration));
    if (isNewSong) {
      player.setUrl(songUrl).then((_) {
        player.play();
      }).catchError((error) {
      });
    }
  }

  void updateSongUrl(String url) {
    songUrl = url;
    prepare(isNewSong: true);
  }

  void dispose() {
    player.dispose();
  }
}

class DurationState {
  const DurationState({
    required this.progress,
    required this.buffered,
    this.total,
  });

  final Duration progress;
  final Duration buffered;
  final Duration? total;
}
