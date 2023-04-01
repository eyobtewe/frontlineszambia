import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../bloc/blocs.dart';
import '../../core/core.dart';
import '../../domain/schemas/schema.dart';
import '../widgets/widgets.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({Key? key}) : super(key: key);

  @override
  _BookmarksScreenState createState() => _BookmarksScreenState();
}

late CacheBloc bloc;
late UiBloc uiBloc;
late Size size;
List<Post> posts = [];

class _BookmarksScreenState extends State<BookmarksScreen> {
  @override
  Widget build(BuildContext context) {
    bloc = CacheProvider.of(context);
    uiBloc = UiProvider.of(context);
    size = MediaQuery.of(context).size;
    // ScreenUtil.init(context, designSize: size, allowFontScaling: true);

    return FutureBuilder(
      future: bloc.fetchSavedPosts(uiBloc.lang),
      builder: (BuildContext context, AsyncSnapshot<List<Post>?> snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            bottomNavigationBar: const BottomBar(index: 2),
            appBar: buildAppBar([], context),
            body: const Center(child: CustomCircularLoader()),
          );
        } else {
          posts = snapshot.data!;

          return posts.isEmpty
              ? Scaffold(
                  bottomNavigationBar: const BottomBar(index: 2),
                  appBar: buildAppBar([], context),
                  body: const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: Icon(Icons.delete_outline_rounded, size: 40),
                    ),
                  ),
                )
              : Scaffold(
                  bottomNavigationBar: const BottomBar(index: 2),
                  appBar: buildAppBar(posts, context),
                  body: buildListView(),
                );
        }
      },
    );
  }

  ListView buildListView() {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int i) =>
          const Divider(color: cTransparent, thickness: 5, height: 10),
      itemCount: posts.length,
      itemBuilder: (_, int i) => PostTile(article: posts.toList()[i], page: 4),
    );
  }
}

AppBar buildAppBar(List<Post> savedArticles, BuildContext context) {
  return AppBar(
    // centerTitle: false,
    // leading: IconButton(
    //   onPressed: () {
    //     Navigator.pop(context);
    //   },
    //   icon: const Icon(Ionicons.chevron_back_sharp, size: 20),
    // ),
    // title: Text(Language.locale(uiBloc.lang, 'favorite')),
    title: Text(
      Language.locale(uiBloc.lang, 'app_name'),
      style: TextStyle(
        color: Theme.of(context).colorScheme.secondary,
        // fontFamily: kOldFonts[0],
        // fontSize: 24,
      ),
    ),
    centerTitle: true,
    actions: [
      savedArticles.isEmpty
          ? Container()
          : IconButton(
              icon: const Icon(Ionicons.trash_sharp),
              onPressed: () async {
                await _showDialog(context);
              },
            ),
    ],
  );
}

_showDialog(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext ctx) => AlertDialog(
      content:
          const Text('Are you sure you want to delete all saved articles?'),
      actions: <Widget>[
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              cGrey,
            ),
          ),
          onPressed: () async {
            await bloc.clearAll(uiBloc.lang);
            // buildShowToast('Deleted all saved articles');
            Navigator.pushNamedAndRemoveUntil(
              context,
              rBookmarkPage,
              (Route<dynamic> route) => false,
            );
          },
          child: const Text(
            'Yes',
            style: TextStyle(color: cWhite),
          ),
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              cPrimaryColor,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'No',
            style: TextStyle(color: cWhite),
          ),
        )
      ],
    ),
  );
}
