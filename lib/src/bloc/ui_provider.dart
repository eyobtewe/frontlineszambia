import 'package:flutter/material.dart';

import 'ui_bloc.dart';

export 'ui_bloc.dart';

class UiProvider extends InheritedWidget {
  final UiBloc bloc;

  UiProvider({Key? key, required Widget child})
      : bloc = UiBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(oldWidget) => true;

  static UiBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<UiProvider>())!.bloc;
  }
  // static ApisBloc of(BuildContext context) {
  //   return context.dependOnInheritedWidgetOfExactType<ApisProvider>() as ApisBloc;
  // }
}
