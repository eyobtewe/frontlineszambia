import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../../../../external_src/random_color/random_color.dart';
import '../../../../bloc/blocs.dart';
import '../../../../core/core.dart';

class PlayerButtons extends StatelessWidget {
  const PlayerButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PlayerBloc playerBloc = PlayerProvider.of(context);
    final Size size = MediaQuery.of(context).size;
    // ScreenUtil.init(context, designSize: size, allowFontScaling: true);
    return Column(
      children: [
        const Divider(color: cTransparent),
        // const MusicProgress(),
        const Divider(color: cTransparent),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const Spacer(),
            buildPrevButton(playerBloc, size),
            buildPlayPauseBtn(playerBloc, size, context),
            buildNextBtn(playerBloc, size),
            const Spacer(),
          ],
        ),
      ],
    );
  }

  Widget buildNextBtn(PlayerBloc playerBloc, Size size) {
    return IconButton(
      iconSize: 28,
      icon: const Icon(Ionicons.play_skip_forward_outline),
      onPressed: playerBloc.audioPlayer.current.value?.hasNext == false
          ? null
          : () {
              playerBloc.audioPlayer.pause();
              playerBloc.audioPlayer.next();
            },
    );
  }

  PlayerBuilder buildPlayPauseBtn(
      PlayerBloc playerBloc, Size size, BuildContext context) {
    return playerBloc.audioPlayer.builderPlayerState(
      builder: (_, PlayerState playerState) {
        return playerBloc.audioPlayer.isBuffering.value
            ? buildBuffering()
            : IconButton(
                iconSize: 50,
                icon: playerState == PlayerState.play
                    ? Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Ionicons.pause_outline,
                            color: Theme.of(context).scaffoldBackgroundColor),
                      )
                    : Container(
                        padding: const EdgeInsets.only(left: 2, right: 2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Ionicons.play_outline,
                            color: Theme.of(context).scaffoldBackgroundColor),
                      ),
                onPressed: () {
                  playerBloc.audioPlayer.playOrPause();
                },
              );
      },
    );
  }

  Stack buildBuffering() {
    RandomColor randomColor = RandomColor();

    // bool isDark = Provider.of<ThemeNotifier>(context).darkTheme;
    List<Color> backgroundColors = randomColor.randomColors(
      count: 3,
      // colorBrightness: isDark ? ColorBrightness.dark : ColorBrightness.light,
      // colorSaturation: ColorSaturation.monochrome,
      // colorSaturation: ColorSaturation.lowSaturation,
    );
    return Stack(
      alignment: Alignment.center,
      children: [
        const IconButton(
          // disabledColor: cPrimaryColor,
          iconSize: 50,
          icon: Icon(Ionicons.pause_circle_outline),
          onPressed: null,
        ),
        // CustomCircularLoader(),
        SleekCircularSlider(
          appearance: CircularSliderAppearance(
            spinnerMode: true,
            size: 40,
            customColors: CustomSliderColors(
              trackColor: backgroundColors[2],
              dotColor: cGrey,
              progressBarColors: [
                backgroundColors[2],
                backgroundColors[0],
                backgroundColors[1],
              ],
            ),
            customWidths: CustomSliderWidths(
              progressBarWidth: 3,
              trackWidth: 3,
            ),
          ),
        ),
      ],
    );
  }

  IconButton buildPrevButton(PlayerBloc playerBloc, Size size) {
    return IconButton(
      iconSize: 28,
      icon: const Icon(Ionicons.play_skip_back_outline),
      onPressed: () {
        playerBloc.audioPlayer.previous();
      },
    );
  }
}
