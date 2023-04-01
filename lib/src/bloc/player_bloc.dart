// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';

import '/src/domain/schemas/schema.dart';

enum PlayerInit { SLEEP, AWAKE }

class PlayerBloc {
  final AssetsAudioPlayer audioPlayer =
      AssetsAudioPlayer.withId('radio_station');

  PlayerInit playerStatus = PlayerInit.SLEEP;
  bool playingLocal = false;

  Future<bool> audioInit(List<RadioStation> station, int index) async {
    List<Audio> audio = setRadioStreams(station);

    try {
      await audioPlayer.open(
        Playlist(audios: audio, startIndex: index),
        loopMode: LoopMode.none,
        forceOpen: true,
        showNotification: true,
        notificationSettings: const NotificationSettings(
          seekBarEnabled: false,
        ),
        playInBackground: PlayInBackground.enabled,
        audioFocusStrategy: const AudioFocusStrategy.request(),
        autoStart: true,
        headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
      );
      playerStatus = PlayerInit.AWAKE;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> stop() async {
    await audioPlayer.stop();
    playerStatus = PlayerInit.SLEEP;
  }

  List<Audio> setRadioStreams(List<RadioStation> stations) {
    return stations.map(
      (station) {
        return Audio.liveStream(
          station.link,
          metas: Metas(
            title: station.name,
            artist: station.subtitle,
            album: station.description,
            onImageLoadFail: const MetasImage.network('path'),
            image: MetasImage.network(station.imgUrl ?? ''),
          ),
        );
      },
    ).toList();
  }
}
