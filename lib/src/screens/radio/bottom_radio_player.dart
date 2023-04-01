import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../bloc/blocs.dart';
import 'package:ionicons/ionicons.dart';
import '../../core/core.dart';

class BottomScreenPlayer extends StatelessWidget {
  const BottomScreenPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PlayerBloc playerBloc = PlayerProvider.of(context);

    return playerBloc.audioPlayer.builderPlayerState(
      builder: (_, PlayerState playerState) {
        if (playerBloc.playerStatus == PlayerInit.SLEEP) {
          return Container(height: 0);
        } else {
          return buildBottom(context, playerBloc);
        }
      },
    );
  }

  Widget buildBottom(BuildContext context, PlayerBloc playerBloc) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          playerBloc.audioPlayer.builderRealtimePlayingInfos(
            builder: (_, RealtimePlayingInfos? rInfo) {
              if (rInfo == null) {
                return const LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(cPrimaryColor),
                  backgroundColor: Colors.black54,
                  value: 0,
                );
              } else {
                return LinearProgressIndicator(
                  minHeight: 2,
                  valueColor: const AlwaysStoppedAnimation(cPrimaryColor),
                  backgroundColor: Colors.black54,
                  value: rInfo.duration.inSeconds != 0
                      ? (rInfo.currentPosition.inSeconds /
                          rInfo.duration.inSeconds)
                      : 0,
                );
              }
            },
          ),
          buildListTile(playerBloc),
        ],
      ),
    );
  }

  Widget buildListTile(PlayerBloc playerBloc) {
    return playerBloc.audioPlayer.builderCurrent(builder: (_, Playing playing) {
      final Metas songMetaData = playing.audio.audio.metas;
      return ListTile(
        leading: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: SizedBox(
                width: 48,
                height: 48,
                child: CachedNetworkImage(
                  imageUrl: songMetaData.image!.path,
                  imageBuilder: (context, imageProvider) {
                    return Image(image: imageProvider);
                  },
                  placeholder: (context, url) => Container(),
                  errorWidget: (context, url, error) => Container(),
                ),
              ),
            ),
            playerBloc.audioPlayer.builderIsPlaying(
              builder: (_, bool isPlaying) {
                return Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.65),
                  ),
                  child: IconButton(
                    color: cPrimaryColor,
                    iconSize: 32,
                    icon: isPlaying
                        ? const Icon(Ionicons.pause_circle)
                        : const Icon(Ionicons.play_circle),
                    onPressed: () {
                      playerBloc.audioPlayer.playOrPause();
                    },
                  ),
                );
              },
            ),
          ],
        ),
        title: Text(
          songMetaData.title ?? '',
          maxLines: 2,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        subtitle: Text(
          songMetaData.artist ?? '',
          maxLines: 1,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        dense: true,
        trailing: IconButton(
            icon: const Icon(Ionicons.close_outline),
            color: cPrimaryColor,
            onPressed: () async {
              await playerBloc.stop();
            }),
      );
    });
  }
}
