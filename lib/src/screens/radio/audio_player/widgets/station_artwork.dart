import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../home/widget/post_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../external_src/random_color/random_color.dart';
import '../../../../bloc/blocs.dart';
import '../../../../helpers/theme_provider.dart';

class StationArtwork extends StatefulWidget {
  const StationArtwork({Key? key, required this.stationArtwork})
      : super(key: key);

  final String stationArtwork;

  @override
  _StationArtworkState createState() => _StationArtworkState();
}

class _StationArtworkState extends State<StationArtwork> {
  late PlayerBloc playerBloc;
  @override
  Widget build(BuildContext context) {
    playerBloc = PlayerProvider.of(context);

    final Size size = MediaQuery.of(context).size;
    RandomColor randomColor = RandomColor();

    bool isDark = Provider.of<ThemeNotifier>(context).darkTheme;
    Color backgroundColor = randomColor.randomColor(
      colorBrightness: isDark ? ColorBrightness.dark : ColorBrightness.light,
      // colorSaturation: ColorSaturation.highSaturation,
    );
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.125),
      child: playerBloc.audioPlayer.builderCurrent(
        builder: (_, Playing playing) {
          return buildStationArtwork(
            playing.audio.audio.metas.image?.path ?? widget.stationArtwork,
            size,
            backgroundColor,
          );
        },
      ),
    );
  }

  Widget buildStationArtwork(String img, Size size, Color backgroundColor) {
    return Center(
      child: AvatarGlow(
        endRadius: size.width * 0.3,
        glowColor: backgroundColor,
        showTwoGlows: true,
        animate: playerBloc.audioPlayer.isPlaying.value,
        duration: const Duration(milliseconds: 2500),
        repeatPauseDuration: Duration.zero,
        child: ClipOval(
          child: SizedBox(
            // height: size.width * 0.5,
            width: size.width * 0.5,
            child: CachedNetworkImage(
              imageUrl: img,
              fit: BoxFit.cover,
              httpHeaders: const {"user-agent": kUserAgent},
              imageBuilder: (context, imageProvider) {
                return Image(image: imageProvider);
              },
              placeholder: (context, url) => Container(),
              errorWidget: (context, url, error) => Container(),
            ),
          ),
        ),
      ),
    );
  }
}
