import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../external_src/random_color/random_color.dart';
import '../../bloc/blocs.dart';
import '../../domain/schemas/schema.dart';
import '../../helpers/theme_provider.dart';
import '../screens.dart';
import '../widgets/bottom_bar.dart';

class RadioStations extends StatefulWidget {
  const RadioStations({Key? key, this.isScreen = true, this.radioStation})
      : super(key: key);
  final bool isScreen;
  final RadioStation? radioStation;

  @override
  _RadioStationsState createState() => _RadioStationsState();
}

class _RadioStationsState extends State<RadioStations> {
  late PlayerBloc playerBloc;
  late ApisBloc apisBloc;
  late Size size;
  // final player = AudioPlayer(
  //   userAgent:
  //       "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.140 Safari/537.36 Edge/17.17134",
  // );
  @override
  Widget build(BuildContext context) {
    playerBloc = PlayerProvider.of(context);
    apisBloc = ApisProvider.of(context);
    final uiBloc = UiProvider.of(context);
    size = MediaQuery.of(context).size;

    return !widget.isScreen
        ? buildBody()
        : Scaffold(
            bottomNavigationBar: const BottomBar(index: 1),
            appBar: buildAppBar(uiBloc, context),
            body: buildBody(),
            // body: Column(
            //   children: [
            //     ElevatedButton.icon(
            //       icon: const Icon(Icons.play_arrow),
            //       label: const Text('Play'),
            //       onPressed: () async {
            //         // await player
            //         //     .setUrl('https://stream.zeno.fm/s7acbwdffv8uv');
            //         // await player.play();
            //         // await playerBloc.audioPlayer.stop();
            //         await playerBloc.audioInit(stations, 0);
            //       },
            //     ),
            //     const BottomScreenPlayer(),
            //   ],
            // ),
          );
  }

  Widget buildBody() {
    return FutureBuilder(
      future: apisBloc.getRadioStations(),
      initialData: apisBloc.radioStations,
      builder: (_, AsyncSnapshot<List<RadioStation>?> snapshot) {
// List<VideoSource> stations =
        // return CircularProgressIndicator.adaptive();
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else {
          return buildGrid(snapshot.data!);

          // return GridView.builder(
          //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 3,
          //     childAspectRatio: 0.5,
          //   ),
          //   itemCount: snapshot.data!.length,
          //   itemBuilder: (_, int index) {
          //     return Column(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         // Image.network(radioStations[index].imgUrl!),
          //         TextButton(
          //           onPressed: () async {
          //             await playerBloc.audioInit(radioStations, index);
          //           },
          //           child: Text(
          //             snapshot.data![index].name,
          //             style: TextStyle(
          //               color: Theme.of(context).colorScheme.secondary,
          //             ),
          //           ),
          //         ),
          //       ],
          //     );
          //     // return GridTile(
          //     //   child: Image.network(
          //     //       snapshot.data![index].imgUrl ?? ''),
          //     //   // child: buildCachedNetworkImage(
          //     //   //     snapshot.data![index].imgUrl ?? ''),
          //     //   footer: const Text('footer'),
          //     //   header: const Text('header'),
          //     // );
          //   },
          // );
        }
      },
    );
  }

  Widget buildGrid(List<RadioStation> radioStations) {
    // List<RadioStation> radioStations = data;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: widget.radioStation != null
          ? radioStations.length - 1
          : radioStations.length,
      primary: widget.isScreen,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        //     return buildSourceCard(context, categories, index, backgroundColors);
        //   },
        // );
        // return StaggeredGridView.countBuilder(
        //   crossAxisCount: 2,
        //   shrinkWrap: true,
        //   primary: widget.isScreen,
        //   itemCount: radioStations.length,
        //   itemBuilder: (BuildContext context, int index) {
        return radioStations[index] == widget.radioStation
            ? Container()
            : InkWell(
                onTap: () async {
                  await playerBloc.audioPlayer.stop();

                  playerBloc.audioInit(radioStations, index);

                  var page = MaterialPageRoute(
                    builder: (_) => AudioPlayerScreen(
                      stations: radioStations,
                      i: index,
                    ),
                  );

                  if (widget.isScreen) {
                    Navigator.push(context, page);
                  } else {
                    Navigator.pushReplacement(context, page);
                  }
                },
                child: buildRadioCard(index, radioStations, context),
              );
      },
      // staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
      // mainAxisSpacing: 4.0,
      // crossAxisSpacing: 4.0,
    );
  }

  Card buildRadioCard(
      int index, List<RadioStation> radioStations, BuildContext context) {
    RandomColor randomColor = RandomColor();

    bool isDark = Provider.of<ThemeNotifier>(context).darkTheme;
    List<Color> backgroundColors = randomColor.randomColors(
      count: widget.radioStation != null
          ? radioStations.length - 1
          : radioStations.length,
      debug: true,
      colorBrightness: isDark ? ColorBrightness.dark : ColorBrightness.light,
      // colorSaturation: ColorSaturation.lowSaturation,
    );

    return Card(
      color: backgroundColors[index],
      child: ClipRRect(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Transform.translate(
                offset: const Offset(5, -5),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Theme.of(context).scaffoldBackgroundColor
                            : Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.5),
                        // .withOpacity(0.5),
                        // color: Theme.of(context)
                        //     .colorScheme
                        //     .secondary
                        //     .withOpacity(0.5),
                        blurRadius: 15,
                        blurStyle: BlurStyle.outer,
                        spreadRadius: 15,
                      ),
                    ],
                    borderRadius: const BorderRadius.all(Radius.circular(500)),
                  ),
                  padding: const EdgeInsets.all(10),
                  // child: Transform.rotate(
                  //   angle: pi / 6,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      errorWidget: (context, url, error) => Container(),
                      imageUrl: radioStations[index].imgUrl!,
                      fit: BoxFit.cover,
                      width: size.width * 0.25,
                      height: size.width * 0.25,
                    ),
                  ),
                  // ),
                ),
              ),
            ),
            //
            Expanded(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    radioStations[index].name,
                    maxLines: 3,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(UiBloc uiBloc, BuildContext context) {
    return AppBar(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      title: Text(
        'Radio Stations',
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          // fontFamily: kOldFonts[0],
          //
          // fontSize: 24,
        ),
      ),
    );
  }
}

// List<Color> bColors = [
//   const Color.fromRGBO(33, 50, 99, 1),
//   const Color.fromRGBO(0, 101, 80, 1),
//   const Color.fromRGBO(253, 100, 55, 1),
//   const Color.fromRGBO(82, 157, 244, 1),
//   const Color.fromRGBO(82, 54, 80, 1),
//   const Color.fromRGBO(255, 206, 215, 1),
//   const Color.fromRGBO(123, 75, 48, 1),
//   const Color.fromRGBO(141, 24, 50, 1),
//   const Color.fromRGBO(196, 122, 84, 1),
// ];
