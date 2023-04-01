import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../bloc/blocs.dart';
import '../../core/core.dart';
import '../../domain/schemas/schema.dart';
// import '../../../external_src/flutter_wordpress.dart';
import '../sources/article_sources_based.dart';
import '../widgets/widgets.dart';

class ArticleSearch extends SearchDelegate<dynamic> {
  ArticleSearch();

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return theme.copyWith(
      inputDecorationTheme: theme.inputDecorationTheme.copyWith(
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Ionicons.close_sharp),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final bloc = ApisProvider.of(context);
    return query != ''
        ? searchFuture(bloc, context)
        : Column(
            children: [
              const Divider(color: cTransparent),
              sourceFuture(bloc, context),
              // tagsFuture(bloc, context),
            ],
          );
  }

  FutureBuilder<List<Post>> searchFuture(ApisBloc bloc, BuildContext context) {
    return FutureBuilder(
      // future: bloc.search(query),
      initialData: bloc.searchResults,
      builder: (_, AsyncSnapshot<List<Post>> snapshot) {
        if (!snapshot.hasData ||
            snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CustomCircularLoader());
        } else if (snapshot.data!.isEmpty) {
          return Center(
              child: Text(
            'No results found',
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ));
        } else {
          return ListView.builder(
            itemBuilder: (_, int k) {
              return PostTile(article: snapshot.data!.toList()[k], page: 1);
            },
            itemCount: snapshot.data!.length,
            shrinkWrap: true,
          );
        }
      },
    );
  }

  Widget sourceFuture(ApisBloc bloc, BuildContext context) {
    return FutureBuilder(
      future: bloc.getNewsSources(),
      initialData: bloc.newsSources,
      builder: (_, AsyncSnapshot<List<NewsSource>?> snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container();
        } else {
          return buildSources(snapshot.data!, context, false);
        }
      },
    );
  }

  // FutureBuilder<List<Tag>> tagsFuture(ApisBloc bloc, BuildContext context) {
  //   return FutureBuilder(
  //     future: bloc.fetchTags(null),
  //     initialData: bloc.tags['search'],
  //     builder: (_, AsyncSnapshot<List<Tag>> snapshot) {
  //       if (!snapshot.hasData || snapshot.data.isEmpty) {
  //         return Container();
  //       } else {
  //         return buildSources(snapshot.data, context, true);
  //       }
  //     },
  //   );
  // }

  Widget buildSources(
      List<dynamic> categories, BuildContext context, bool isTag) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              isTag ? 'Topics of Interest' : 'Popular Sources',
              style: TextStyle(
                // fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 14,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildSourceBtn(context, categories[0], isTag),
                  buildSourceBtn(context, categories[1], isTag),
                  buildSourceBtn(context, categories[2], isTag),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSourceBtn(context, categories[3], isTag),
                  buildSourceBtn(context, categories[4], isTag),
                  buildSourceBtn(context, categories[5], isTag),
                ],
              ),
              !isTag
                  ? Container()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildSourceBtn(context, categories[6], isTag),
                        buildSourceBtn(context, categories[7], isTag),
                        buildSourceBtn(context, categories[8], isTag),
                      ],
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSourceBtn(BuildContext context, dynamic e, bool isTag) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) {
              return
                  // !isTag
                  // ?
                  ArticleSourcesBased(newsSource: e.name);
              // : ArticleSourcesBased(tag: e);
            },
          ),
        );
      },
      // style: ButtonStyle(
      // backgroundColor: MaterialStateProperty.all(
      //   Theme.of(context).colorScheme.secondary.withOpacity(0.1),
      // ),
      // visualDensity: VisualDensity(vertical: -2),
      // shape: MaterialStateProperty.all(
      //   RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(50),
      //   ),
      // ),
      // ),
      child: buildBtnLabel(e, context),
    );
  }

  Widget buildBtnLabel(dynamic e, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        e.name,
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
