import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

import '../../../../bloc/blocs.dart';
import '../../../../domain/schemas/schema.dart';

class StationDetails extends StatelessWidget {
  const StationDetails({Key? key, required this.station}) : super(key: key);
  final RadioStation station;

  @override
  Widget build(BuildContext context) {
    final playerBloc = PlayerProvider.of(context);

    // Audio station = playerBloc.audioPlayer.readingPlaylist!.current;

    return playerBloc.audioPlayer.builderCurrent(
      builder: (_, Playing playing) {
        Metas metas = playing.audio.audio.metas;

        return Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: Text(
                metas.title ?? station.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  // color: cGray,
                ),
              ),
            ),
            metas.title == metas.artist || station.name == station.subtitle
                ? Container()
                : Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    child: Text(
                      metas.artist ?? station.subtitle ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
            // metas.album == null && station.description == null
            //     ? Container()
            //     : Container(
            //         padding:
            //             const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
            //         child: Text(
            //           metas.album ?? station.description ?? '',
            //           style: const TextStyle(
            //             fontSize: 12,
            //           ),
            //         ),
            //       ),
          ],
        );
      },
    );
  }
}
