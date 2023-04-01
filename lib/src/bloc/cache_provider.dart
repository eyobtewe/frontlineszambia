import 'package:flutter/material.dart';

import 'cache_bloc.dart';

export 'cache_bloc.dart';

class CacheProvider extends InheritedWidget {
  final CacheBloc bloc;

  CacheProvider({Key? key, required Widget child})
      : bloc = CacheBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(oldWidget) => true;

  static CacheBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<CacheProvider>())!.bloc;
  }
  // static ApisBloc of(BuildContext context) {
  //   return context.dependOnInheritedWidgetOfExactType<ApisProvider>() as ApisBloc;
  // }
}
