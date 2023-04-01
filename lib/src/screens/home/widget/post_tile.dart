import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../bloc/blocs.dart';
import '../../../domain/schemas/schema.dart';
import '../../screens.dart';
import '../../widgets/widgets.dart';

class PostTile extends StatefulWidget {
  const PostTile(
      {Key? key,
      required this.article,
      required this.page,
      this.isFromSource = false})
      : super(key: key);

  final int page;
  final Post article;
  final bool isFromSource;

  @override
  _PostTileState createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  late ApisBloc aBloc;
  late UiBloc uiBloc;
  late CacheBloc cacheBloc;
  late Size size;
  @override
  Widget build(BuildContext context) {
    aBloc = ApisProvider.of(context);
    uiBloc = UiProvider.of(context);
    cacheBloc = CacheProvider.of(context);

    size = MediaQuery.of(context).size;
    // ScreenUtil.init(context, designSize: size, allowFontScaling: true);

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return PostDetail(post: widget.article);
            },
          ),
        );
      },
      child: Card(
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        elevation: 0,
        // shadowColor: Colors.white54,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          height: 90,
          width: size.width,
          child: Row(
            children: <Widget>[
              buildContent(),
              widget.page != 1 ? Container() : buildFeatureImage(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContent() {
    return Expanded(
      flex: 8,
      child: LayoutBuilder(
        builder: (_, BoxConstraints constraints) {
          return Container(
            // width: (8 / 13 * size.width - 10),
            padding:
                const EdgeInsets.only(top: 3, bottom: 3, right: 10, left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                PostTitle(article: widget.article),
                PostTimeAndIconBtns(
                  article: widget.article,
                  page: widget.page,
                  isFromSource: widget.isFromSource,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildFeatureImage(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.article.featuredMedia?.sourceUrl ?? '',
      httpHeaders: const {"user-agent": kUserAgent},
      imageBuilder: (_, imageProvider) {
        return Container(
          margin: const EdgeInsets.only(right: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image(
              image: imageProvider,
              height: 80,
              width: 120,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
      placeholder: (context, url) => Container(),
      errorWidget: (context, url, error) => const SizedBox(height: 0, width: 0),
    );
  }
}

String textCleanUp(String titles) {
  titles = titles.replaceAll(RegExp(r'&#8217;'), "’");
  titles = titles.replaceAll(RegExp(r'&#8216;'), "‘");
  titles = titles.replaceAll(RegExp(r'&#8220;'), '“');
  titles = titles.replaceAll(RegExp(r'&#038;'), "&");
  titles = titles.replaceAll(RegExp(r'&#8221;'), '”');
  titles = titles.replaceAll(RegExp(r'&#8211;'), '–');
  titles = titles.replaceAll(RegExp(r'&#8230;'), '...');
  titles = titles.replaceAll(RegExp(r'&nbsp;'), ' ');
  return titles;
}

const String kUserAgent =
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36 Edg/91.0.864.59";
