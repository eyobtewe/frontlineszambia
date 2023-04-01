import 'package:flutter/material.dart';

import 'player_bloc.dart';

export 'player_bloc.dart';

class PlayerProvider extends InheritedWidget {
  final PlayerBloc bloc;

  PlayerProvider({Key? key, required Widget child})
      : bloc = PlayerBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(oldWidget) => true;

  static PlayerBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<PlayerProvider>())!.bloc;
  }
}
