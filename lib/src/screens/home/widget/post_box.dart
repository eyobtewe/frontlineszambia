import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../../../domain/schemas/schema.dart';
import '../../screens.dart';
import '../../widgets/widgets.dart';

class PostBox extends StatelessWidget {
  const PostBox({Key? key, required this.article, this.factor})
      : super(key: key);

  final Post article;
  final double? factor;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // ScreenUtil.init(context, designSize: size, allowFontScaling: true);

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return PostDetail(post: article);
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
        shadowColor: Colors.white54,
        child: Container(
          width: size.width,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              buildImages(size, context),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(
                    top: 10, bottom: 0, right: 10, left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: PostTitle(article: article),
                      color: cTransparent,
                    ),
                    const Divider(color: cTransparent),
                    PostTimeAndIconBtns(article: article, page: 1),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImages(Size size, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: Container(
          color: cTransparent,
          child: CachedNetworkImage(
            httpHeaders: const {"user-agent": kUserAgent},
            imageUrl: article.featuredMedia!.sourceUrl!,
            imageBuilder: (context, imageProvider) {
              return Container(
                height: MediaQuery.of(context).size.width * 9 / 18,
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
        ),
      ),
    );
  }
}
