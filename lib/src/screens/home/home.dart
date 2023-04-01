import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../bloc/blocs.dart';
import '../../core/core.dart';
import '../../domain/schemas/schema.dart';
import '../../domain/services/dynamic_link.dart';
import '../screens.dart';
import '../widgets/widgets.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ApisBloc aBloc;
  late UiBloc uiBloc;
  late Size size;

  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();

    checkDynamicLinks();
    scrollController = ScrollController();
    scrollController.addListener(_listener);
  }

  void _listener() {
    if (scrollController.position.atEdge &&
        scrollController.position.pixels != 0) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_listener);
    scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    uiBloc = UiProvider.of(context);
    aBloc = ApisProvider.of(context);
    size = MediaQuery.of(context).size;

    // ScreenUtil.init(context, designSize: size, allowFontScaling: true);

    return Scaffold(
      appBar: buildAppBar(context),
      bottomNavigationBar: const BottomBar(index: 0),
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onPressed: () {
          aBloc.clearData();
          Navigator.pushNamedAndRemoveUntil(
            context,
            rHomePage,
            (route) => false,
          );
        },
        mini: true,
        child: Icon(
          Icons.refresh,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
      body: RefreshIndicator(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        color: Theme.of(context).scaffoldBackgroundColor,
        strokeWidth: 3,
        onRefresh: () async {
          aBloc.clearData();
          Navigator.pushNamedAndRemoveUntil(
            context,
            rHomePage,
            (route) => false,
          );
        },
        child: buildBody(),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      title: Text(
        Language.locale(uiBloc.lang, 'app_name'),
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget buildBody() {
    return FutureBuilder(
      future: aBloc.getPosts(),
      initialData: aBloc.posts,
      builder: (_, AsyncSnapshot<List<Post>?> snapshot) {
        final Widget refresh = buildNoConnection(
          () {
            aBloc.clearData();
            Navigator.pushNamedAndRemoveUntil(
                context, rHomePage, (route) => false);
          },
          uiBloc,
        );

        if (!snapshot.hasData) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(child: refresh);
          } else {
            return const Center(
              child: CustomCircularLoader(),
            );
          }
        } else {
          return buildContentUi(snapshot.data!);
        }
      },
    );
  }

  Widget buildContentUi(List<Post> posts) {
    return ListView.separated(
      itemCount: posts.length,
      controller: scrollController,
      shrinkWrap: true,
      separatorBuilder: (_, int index) {
        return ((index + 2) % 5 == 0 && (index + 2) != 0)
            ? const CustomNativeAds()
            : Container();
      },
      itemBuilder: (_, int index) {
        if (index % 10 == 0) {
          return PostBox(article: posts.toList()[index]);
        } else if (index % 10 < 5) {
          return Column(
            children: [
              PostTile(article: posts.toList()[index], page: 1),
              // (index + 1) == posts.length
              // ? const Center(child: CustomCircularLoader())
              // : Container(),
            ],
          );
        } else {
          return Column(
            children: [
              PostTile(
                article: posts.toList()[index],
                page: 2,
              ),
              // (index + 1) == posts.length
              // ? const Center(child: CustomCircularLoader())
              // : Container(),
            ],
          );
        }
      },
    );
  }

  void checkDynamicLinks() async {
    await kDynamicLinkService.handleDynamicLinks(
      onLinkFound: (Map<String, String> id) {
        return Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PostDetail(id: id),
          ),
        );
      },
    );
  }
}

Widget buildCachedNetworkImage(String url) {
  return Container(
    color: cTransparent,
    child: CachedNetworkImage(
      imageUrl: url,
      httpHeaders: const {"user-agent": kUserAgent},
      imageBuilder: (_, imageProvider) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
      placeholder: (context, url) => const SizedBox(height: 0, width: 0),
      errorWidget: (context, url, error) => Container(),
    ),
  );
}
