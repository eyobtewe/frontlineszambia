import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../domain/schemas/schema.dart';

import '../../bloc/blocs.dart';
import '../widgets/widgets.dart';

class ArticleSourcesBased extends StatefulWidget {
  const ArticleSourcesBased({
    Key? key,
    required this.newsSource,
    // this.id,
    // this.tag,
  }) : super(key: key);
  final String newsSource;
  // final int id;
  // final Tag tag;
  @override
  _ArticleSourcesBasedState createState() => _ArticleSourcesBasedState();
}

class _ArticleSourcesBasedState extends State<ArticleSourcesBased> {
  late ApisBloc aBloc;
  late UiBloc uiBloc;
  late Size size;

  late ScrollController scrollController;
  int page = 1;

  @override
  Widget build(BuildContext context) {
    uiBloc = UiProvider.of(context);
    aBloc = ApisProvider.of(context);
    size = MediaQuery.of(context).size;

    // ScreenUtil.init(context, designSize: size, allowFontScaling: true);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Ionicons.chevron_back_sharp, size: 20),
        ),
        title: Text(
          widget.newsSource,
          //  widget.tag.name ??
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return FutureBuilder(
      // future: aBloc.fetchPosts(widget.id, 1, 25, tag: widget.tag),
      future:
          aBloc.getPosts(source: NewsSource(name: widget.newsSource, url: '')),
      initialData: aBloc.sourceBasedPosts[widget.newsSource],
      builder: (_, AsyncSnapshot<List<Post>?> snapshot) {
        final Widget refresh = buildNoConnection(() => setState(() {}), uiBloc);

        if (!snapshot.hasData) {
          if (snapshot.connectionState == ConnectionState.done) {
            return refresh;
          } else {
            return const Center(
              child: CustomCircularLoader(),
            );
          }
        } else if (snapshot.data!.isEmpty) {
          return refresh;
        } else {
          return buildResult(snapshot.data!);
        }
      },
    );
  }

  Widget buildResult(List<Post> snapshot) {
    return ListView.builder(
      itemBuilder: (BuildContext ctx, int index) {
        return PostTile(
          article: snapshot.toList()[index],
          page: 1,
          // isFromSource: widget.newsSource != null ? false : true,
          isFromSource: false,
        );
      },
      itemCount: snapshot.length,
    );
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(_listener);
  }

  void _listener() {
    if (scrollController.position.atEdge &&
        scrollController.position.pixels != 0) {
      setState(() {
        page++;
      });
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_listener);
    scrollController.dispose();
    super.dispose();
  }
}
