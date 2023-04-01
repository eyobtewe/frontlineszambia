import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:share/share.dart';

import '../../../bloc/blocs.dart';
import '../../../core/core.dart';
import '../../../domain/schemas/schema.dart';
import '../../screens.dart';
import 'widgets/widgets.dart';

class AudioPlayerScreen extends StatefulWidget {
  final List<RadioStation> stations;
  final int i;

  const AudioPlayerScreen({
    Key? key,
    required this.stations,
    required this.i,
  }) : super(key: key);
  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late PlayerBloc playerBloc;
  late ApisBloc bloc;
  late UiBloc uiBloc;
  late Size size;

  @override
  Widget build(BuildContext context) {
    playerBloc = PlayerProvider.of(context);
    bloc = ApisProvider.of(context);
    uiBloc = UiProvider.of(context);
    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        widget.stations[widget.i].name,
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          // fontFamily: kOldFonts[0],
          // fontSize: 24,
        ),
      ),
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Ionicons.share_social_outline),
          onPressed: () {
            // final String link = await kDynamicLinkService
            //     .createDynamicLink(widget.stations[widget.i]);
            Share.share('');
            // Share.share(
            //     '${widget.stations[widget.i].title} - ${widget.stations[widget.i].artistStatic.fullName} \n\n$link');
          },
        ),
      ],
    );
  }

  Widget buildBody() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
        StationArtwork(stationArtwork: widget.stations[widget.i].imgUrl!),
        const Divider(color: cTransparent),
        StationDetails(station: widget.stations[widget.i]),
        const PlayerButtons(),
        const Divider(color: cTransparent),

        // buildContainer(),
        RadioStations(
          isScreen: false,
          radioStation: widget.stations[widget.i],
        )
      ],
    );
  }
}
