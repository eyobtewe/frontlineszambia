import 'package:flutter/material.dart';

import '../../bloc/blocs.dart';
import '../../core/core.dart';

class DynamicSliverAppBar extends StatefulWidget {
  const DynamicSliverAppBar({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  _DynamicSliverAppBarState createState() => _DynamicSliverAppBarState();
}

class _DynamicSliverAppBarState extends State<DynamicSliverAppBar> {
  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    final uiBloc = UiProvider.of(context);
    // ScreenUtil.init(context, allowFontScaling: true, designSize: size);
    return SliverAppBar(
      pinned: true,
      // floating: true,
      // snap: true,
      title: Text(
        Language.locale(uiBloc.lang, 'app_name'),
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          // fontFamily: GoogleFonts.ptSans().fontFamily,
          //
          // fontSize: 24,
        ),
      ),
    );
  }
}
