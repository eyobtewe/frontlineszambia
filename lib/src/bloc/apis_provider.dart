import 'package:flutter/material.dart';

import 'apis_bloc.dart';

export 'apis_bloc.dart';

class ApisProvider extends InheritedWidget {
  final ApisBloc bloc;

  ApisProvider({Key? key, required Widget child})
      : bloc = ApisBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(oldWidget) => true;

  static ApisBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ApisProvider>())!.bloc;
  }
  // static ApisBloc of(BuildContext context) {
  //   return context.dependOnInheritedWidgetOfExactType<ApisProvider>() as ApisBloc;
  // }
}
