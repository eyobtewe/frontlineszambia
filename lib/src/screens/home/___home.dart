// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:ionicons/ionicons.dart';
// import 'src/core/core.dart';
// import 'src/helpers/custome_time_formatter.dart';
// import '../../core/app_colors.dart';

// import '../../domain/schemas/schema.dart';
// import '../../bloc/blocs.dart';
// import '../../domain/services/dynamic_link.dart';
// import '../screens.dart';
// import '../widgets/widgets.dart';

// enum VIEW { normal, grid, tile, masonary }

// class Home extends StatefulWidget {
//   const Home({Key? key }) : super(key: key);
//   @override
//   _HomeState createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   ApisBloc aBloc;
//   UiBloc uiBloc;
//   Size size;

//   ScrollController scrollController;
//   int page = 1;

//   VIEW uiStyle = VIEW.normal;

//   @override
//   Widget build(BuildContext context) {
//     uiBloc = UiProvider.of(context);
//     aBloc = ApisProvider.of(context);
//     size = MediaQuery.of(context).size;

//     // ScreenUtil.init(context, designSize: size, allowFontScaling: true);

//     return Scaffold(
//       bottomNavigationBar: BottomBar(index: 0),
//       body: RefreshIndicator(
//         onRefresh: () async {
//           aBloc.clearData();
//           // aBloc.init();
//           setState(() {});
//         },
//         child: CustomScrollView(
//           controller: scrollController,
//           shrinkWrap: true,
//           slivers: [
//             // DynamicSliverAppBar(),
//             buildSliverAppBar(context),
//             buildBody(),
//           ],
//         ),
//       ),
//     );
//   }

//   SliverAppBar buildSliverAppBar(BuildContext context) {
//     return SliverAppBar(
//       pinned: true,
//       // floating: true,
//       // snap: true,
//       title: Text(
//         Language.locale(uiBloc.lang, 'app_name'),
//         style: TextStyle(
//           color: Theme.of(context).colorScheme.secondary,
//           fontFamily: kOldFonts[0],
//           // 
//           fontSize: ScreenUtil().setSp(32),
//         ),
//       ),
//       actions: [
//         IconButton(
//           onPressed: () {
//             if (uiStyle == VIEW.tile) {
//               setState(() {
//                 uiStyle = VIEW.grid;
//               });
//             } else if (uiStyle == VIEW.grid) {
//               setState(() {
//                 uiStyle = VIEW.masonary;
//               });
//             } else if (uiStyle == VIEW.masonary) {
//               setState(() {
//                 uiStyle = VIEW.normal;
//               });
//             } else {
//               setState(() {
//                 uiStyle = VIEW.tile;
//               });
//             }
//           },
//           icon: Icon(
//             uiStyle == VIEW.normal
//                 ? Ionicons.list_outline
//                 : uiStyle == VIEW.tile
//                     ? Ionicons.tablet_landscape_outline
//                     : uiStyle == VIEW.grid
//                         ? Icons.auto_awesome_mosaic_outlined
//                         : Icons.article_outlined,
//           ),
//         )
//       ],
//     );
//   }

//   Widget buildBody() {
//     return FutureBuilder(
//       future: aBloc.getPosts(),
//       initialData: aBloc.posts,
//       builder: (_, AsyncSnapshot<List<Post>> snapshot) {
//         final onPressed = () => setState(() {});
//         final Widget refresh = buildNoConnection(onPressed, uiBloc);

//         if (!snapshot.hasData || snapshot.data.isEmpty) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return SliverFillRemaining(child: refresh);
//           } else {
//             return SliverFillRemaining(
//               child: Center(
//                 child: CustomCircularLoader(),
//               ),
//             );
//           }
//         } else {
//           return buildCustomScrollView(snapshot.data);
//         }
//       },
//     );
//   }

//   Widget buildCustomScrollView(List<Post> snapshot) {
//     if (uiStyle == VIEW.masonary) {
//       return SliverFillRemaining(
//         child: buildPostMasonary(snapshot),
//         hasScrollBody: true,
//         // fillOverscroll: true,
//       );
//     } else {
//       return SliverList(
//         delegate: SliverChildBuilderDelegate(
//           (_, int index) {
//             switch (uiStyle) {
//               case VIEW.tile:
//                 return PostTile(article: snapshot[index], page: 1);
//               case VIEW.grid:
//                 return PostBox(article: snapshot[index]);
//               case VIEW.normal:
//               default:
//                 {
//                   if (index % 7 == 0) {
//                     return PostBox(article: snapshot[index]);
//                   } else {
//                     return PostTile(article: snapshot[index], page: 1);
//                   }
//                 }
//                 break;
//             }
//           },
//           childCount: snapshot.length,
//         ),
//       );
//     }
//   }

//   Widget buildPostMasonary(List<Post> snapshot) {
//     return StaggeredGridView.countBuilder(
//       crossAxisCount: 2,
//       shrinkWrap: true,
//       primary: false,
//       itemCount: snapshot.length,
//       itemBuilder: (BuildContext context, int index) {
//         return InkWell(
//             onTap: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (_) {
//                     return PostDetail(post: snapshot[index]);
//                   },
//                 ),
//               );
//             },
//             child: PostBox(article: snapshot[index])
//             // child: buildCard(context, snapshot, index),
//             );
//       },
//       staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
//       mainAxisSpacing: 4.0,
//       crossAxisSpacing: 4.0,
//     );
//   }

//   Card buildCard(BuildContext context, List<Post> snapshot, int index) {
//     return Card(
//       elevation: 0,
//       color: Theme.of(context).scaffoldBackgroundColor,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.vertical(top: Radius.circular(3)),
//             child: CachedNetworkImage(
//               imageUrl: snapshot[index].featuredMedia?.sourceUrl ?? '',
//               imageBuilder: (context, imageProvider) {
//                 return Image(image: imageProvider);
//               },
//               placeholder: (context, url) => Container(),
//               errorWidget: (context, url, error) => Container(),
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
//             child: PostTitle(article: snapshot[index]),
//             color: cTransparent,
//           ),
//           Divider(color: cTransparent),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
//             child: PostTimeAndIconBtns(article: snapshot[index], page: 1),
//           ),
//         ],
//       ),
//     );
//   }

//   void checkDynamicLinks() async {
//     await kDynamicLinkService.handleDynamicLinks(
//       onLinkFound: (Map<String, String> id) {
//         if (id != null) {
//           return Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (_) => PostDetail(id: id),
//             ),
//           );
//         }
//       },
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     checkDynamicLinks();
//     scrollController = ScrollController();
//     scrollController.addListener(_listener);
//   }

//   void _listener() {
//     if (scrollController.position.atEdge && scrollController.position.pixels != 0) {
//       // debugPrint('\n\n\t\tTRIGGERED\n\n');
//       setState(() {
//         page++;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     scrollController.removeListener(_listener);
//     scrollController.dispose();
//     super.dispose();
//   }
// }

// Widget buildCachedNetworkImage(String url) {
//   return Container(
//     color: cTransparent,
//     child: CachedNetworkImage(
//       imageUrl: url,
//       imageBuilder: (_, imageProvider) {
//         return Container(
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: imageProvider,
//               fit: BoxFit.cover,
//             ),
//           ),
//         );
//       },
//       placeholder: (context, url) => Container(height: 0, width: 0),
//       errorWidget: (context, url, error) => Container(),
//     ),
//   );
// }
