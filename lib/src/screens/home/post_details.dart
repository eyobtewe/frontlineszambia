import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:ionicons/ionicons.dart';
import '../../domain/schemas/schema.dart';
import '../sources/article_sources_based.dart';
import 'package:share/share.dart';

import '../../bloc/blocs.dart';
import '../../core/core.dart';
import '../../domain/services/dynamic_link.dart';
import '../../helpers/html_parser.dart';
import '../widgets/widgets.dart';

class PostDetail extends StatefulWidget {
  final Map? id;
  final Post? post;

  const PostDetail({Key? key, this.id, this.post}) : super(key: key);

  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  late CacheBloc cacheBloc;
  late Size size;
  late UiBloc uiBloc;
  late ApisBloc aBloc;
  bool isChecked = false;

  @override
  void initState() {
    super.initState();

    if (widget.post != null) {
      isSaved();
    }
  }

  void isSaved() async {
    isChecked = await lookInFavorites(widget.post!);
  }

  @override
  Widget build(BuildContext context) {
    cacheBloc = CacheProvider.of(context);
    aBloc = ApisProvider.of(context);
    uiBloc = UiProvider.of(context);
    size = MediaQuery.of(context).size;

    // ScreenUtil.init(context, designSize: size, allowFontScaling: true);
    return Scaffold(
      body: widget.id != null
          ? FutureBuilder(
              future: aBloc.getPosts(id: widget.id),
              // future: aBloc.fetchPosts(null, 1, 1,
              //     includePost: [int.parse(widget.id.values.first)]),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Post>?> snaphshot) {
                if (!snaphshot.hasData) {
                  return CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        pinned: true,
                        elevation: 0,
                        leading: buildBackBtn(context),
                      ),
                      const SliverFillRemaining(
                        child: Center(child: CustomCircularLoader()),
                      ),
                    ],
                  );
                } else {
                  return buildBody(snaphshot.data!.first);
                }
              },
            )
          : buildBody(widget.post!),
    );
  }

  IconButton buildBackBtn(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const Icon(Ionicons.chevron_back_sharp, size: 20),
    );
  }

  Widget buildBody(Post article) {
    final DateTime time = DateTime.parse(article.date!);
    String datePublished =
        '${uiBloc.lang == 'am' ? Months.amharic[time.month - 1] : uiBloc.lang == 'tg' ? Months.tigrigna[time.month - 1] : Months.english[time.month - 1]} ${time.day}, ${time.year}';

    return CustomScrollView(
      shrinkWrap: true,
      slivers: [
        buildSliverAppBar(article),
        SliverList(
          delegate: SliverChildListDelegate.fixed(
            [
              buildText(article.title!.rendered, 30, true),
              buildSourceBtn(article),
              buildText(datePublished, 14, false),
              buildFeatureImage(article),

              buildContent(article),

              // buildTags(article),
              const Divider(color: cTransparent),
              const CustomNativeAds(isSmall: false),
              const Divider(color: cTransparent),
            ],
          ),
        ),
      ],
    );
  }

  // Padding buildTags(Post article) {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: FutureBuilder(
  //       initialData: aBloc.tags[article.id.toString()],
  //       future: aBloc.fetchTags(article),
  //       builder: (_, AsyncSnapshot<List<Tag>> snapshot) {
  //         if (!snapshot.hasData) {
  //           return Container();
  //         } else {
  //           return Wrap(
  //             children: snapshot.data.map((tag) {
  //               return Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 5),
  //                 child: buildTagBtn(tag),
  //               );
  //             }).toList(),
  //           );
  //         }
  //       },
  //     ),
  //   );
  // }
  // TextButton buildTagBtn(Tag tag) {
  //   return TextButton(
  //     style: ButtonStyle(
  //       visualDensity: VisualDensity(horizontal: 0, vertical: -1),
  //       alignment: Alignment.center,
  //       backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary),
  //     ),
  //     onPressed: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (_) => ArticleSourcesBased(),
  //         ),
  //       );
  //     },
  //     child: Text(
  //       tag.name,
  //       style: TextStyle(
  //
  //         fontFamily: (uiBloc.lang == 'en' || uiBloc.lang == 'all')
  //             ? GoogleFonts.dmSerifDisplay().fontFamily
  //             : 'Ny',
  //         color: Theme.of(context).scaffoldBackgroundColor,
  //         fontWeight: FontWeight.normal,
  //         fontSize: 14,
  //       ),
  //     ),
  //   );
  // }

  Widget buildSourceBtn(Post article) {
    return article.source == ''
        ? Container()
        : Row(
            children: [
              TextButton(
                style: ButtonStyle(
                  visualDensity:
                      const VisualDensity(horizontal: 1, vertical: -2),
                  alignment: Alignment.centerLeft,
                  backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ArticleSourcesBased(
                        newsSource: article.source!,
                        // id: article.categories.first,
                      ),
                    ),
                  );
                },
                child: Text(
                  article.source!,
                  style: TextStyle(
                    // fontFamily:'OpenSans',
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          );
  }

  SliverAppBar buildSliverAppBar(Post article) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      pinned: true,
      elevation: 0,
      leading: buildBackBtn(context),
      // iconTheme: IconThemeData(color: cBlack),
      // actionsIconTheme: IconThemeData(color: cBlack),
      actions: [
        IconButton(
          onPressed: () async {
            if (isChecked) {
              await cacheBloc.removeFavorites(widget.post!, uiBloc.lang);
              setState(() {
                isChecked = !isChecked;
              });
            } else {
              await cacheBloc.addToFavorites(widget.post!, uiBloc.lang);
              setState(() {
                isChecked = !isChecked;
              });
            }
            // Navigator.pop(context);
          },
          icon: Icon(
            (isChecked) ? Ionicons.bookmark_sharp : Ionicons.bookmark_outline,
          ),
          iconSize: 20,
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
          constraints: const BoxConstraints(minHeight: 30, minWidth: 30),
        ),
        IconButton(
          icon: const Icon(Icons.share),
          iconSize: 18,
          onPressed: () async {
            final link = await kDynamicLinkService.createDynamicLink(
                article, uiBloc.lang);

            // String summary = article.excerpt.rendered;
            // summary.replaceAll(RegExp(r'<p>|</p>'), '');
            String title = textCleanUp(article.title!.rendered);

            Share.share(
              '${Language.locale(uiBloc.lang, 'app_name')}: $title\n\n$link',
              subject: '${Language.locale(uiBloc.lang, 'app_name')}: $title',
            );
          },
        ),
      ],
    );
  }

  Widget buildFeatureImage(Post article) {
    return article.featuredMedia != null
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            child: buildCachedNetworkImage(article.featuredMedia!.sourceUrl!),
          )
        : Container();
  }

  Container buildText(String title, int fontSize, bool emphasis) {
    String t = textCleanUp(title);
    return title == 'null'
        ? Container()
        : Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: !emphasis ? 12 : 10),
            child: SelectableText(
              t,
              toolbarOptions: const ToolbarOptions(
                copy: true,
                selectAll: true,
              ),
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .secondary
                    .withOpacity(emphasis ? 1 : 0.8),
                fontWeight: emphasis ? FontWeight.w900 : FontWeight.w600,
                fontSize: fontSize.toDouble(),
                // fontFamily: emphasis ? 'Oswald' : 'OpenSans',
              ),
            ),
          );
  }

  Widget buildContent(Post post) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: HtmlParser(
        child: post,
        fontSize: 16,
        // fontFamily: 'OpenSans',
      ),
    );
  }

  Widget buildCachedNetworkImage(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      httpHeaders: const {"user-agent": kUserAgent},
      imageBuilder: (context, imageProvider) {
        return Image(image: imageProvider);
      },
      placeholder: (context, url) => Container(),
      errorWidget: (context, url, error) => Container(),
    );
  }
}
