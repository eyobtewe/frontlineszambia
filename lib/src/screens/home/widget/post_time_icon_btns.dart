import 'package:flutter/material.dart';

import '../../../bloc/blocs.dart';
import '../../../domain/schemas/schema.dart';
import '../../../helpers/custome_time_formatter.dart';

class PostTimeAndIconBtns extends StatefulWidget {
  const PostTimeAndIconBtns({
    Key? key,
    required this.article,
    this.page,
    this.isFromSource = false,
  }) : super(key: key);

  final Post article;
  final int? page;
  final bool isFromSource;

  @override
  _PostTimeAndIconBtnsState createState() => _PostTimeAndIconBtnsState();
}

class _PostTimeAndIconBtnsState extends State<PostTimeAndIconBtns> {
  late ApisBloc aBloc;
  late UiBloc uiBloc;
  late CacheBloc cacheBloc;
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    isSaved();
  }

  void isSaved() async {
    isChecked = await lookInFavorites(widget.article);
  }

  @override
  Widget build(BuildContext context) {
    cacheBloc = CacheProvider.of(context);
    aBloc = ApisProvider.of(context);
    uiBloc = UiProvider.of(context);

    // final Size size = MediaQuery.of(context).size;
    // ScreenUtil.init(context, designSize: size, allowFontScaling: true);

    String timeAgo;
    var time = DateTime.parse(widget.article.date!);
    int timeStamp = time.millisecondsSinceEpoch;

    timeAgo = TimeAgo.getTimeAgo(timeStamp);
    TextStyle textStyle = TextStyle(
      color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
      // fontWeight: FontWeight.bold,
      fontSize: 10,
      // fontFamily: 'OpenSans',
    );
    return Container(
      child: widget.isFromSource || widget.article.source == ''
          ? Text(timeAgo, style: textStyle)
          : RichText(
              text: TextSpan(
                text: widget.article.source,
                style: textStyle,
                children: [
                  TextSpan(text: ' ٠ ', style: textStyle),
                  TextSpan(text: timeAgo, style: textStyle)
                ],
              ),
            ),
    );
  }

  // Widget buildSaved(int page) {
  //   return IconButton(
  //     onPressed: () async {
  //       if (page == 4) {
  //         await cacheBloc.removeFavorites(widget.article, uiBloc.lang);
  //         Navigator.pushReplacementNamed(context, rBookmarkPage);
  //       } else {
  //         if (isChecked) {
  //           await cacheBloc.removeFavorites(widget.article, uiBloc.lang);
  //           setState(() {
  //             isChecked = !isChecked;
  //           });
  //         } else {
  //           await cacheBloc.addToFavorites(widget.article, uiBloc.lang);
  //           setState(() {
  //             isChecked = !isChecked;
  //           });
  //         }
  //         // Navigator.pop(context);
  //       }
  //     },
  //     icon: Icon(
  //       (page == 2 || isChecked) ? Ionicons.bookmark_sharp : Ionicons.bookmark_outline,
  //     ),
  //     iconSize: 20,
  //     color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
  //     constraints: BoxConstraints(minHeight: 30, minWidth: 30),
  //   );
  // }

  // Widget buildShareBtn() {
  //   return IconButton(
  //     onPressed: () async {
  //       String link = await kDynamicLinkService.createDynamicLink(widget.article, uiBloc.lang);
  //       // Navigator.pop(context);
  //       String title = textCleanUp('${widget.article.title.rendered}');

  //       Share.share(
  //         Language.locale(uiBloc.lang, 'app_name') + ': $title\n\n$link',
  //         subject: Language.locale(uiBloc.lang, 'app_name') + ': $title',
  //       );
  //     },
  //     icon: Icon(Icons.share_outlined),
  //     iconSize: 20,
  //     color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
  //     constraints: BoxConstraints(
  //       minHeight: 30,
  //       minWidth: 30,
  //     ),
  //   );
  // }

}
