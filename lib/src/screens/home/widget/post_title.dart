import 'package:flutter/material.dart';

import '../../../domain/schemas/schema.dart';
import '../../widgets/widgets.dart';

class PostTitle extends StatelessWidget {
  const PostTitle({Key? key, required this.article}) : super(key: key);

  final Post article;

  @override
  Widget build(BuildContext context) {
    String title = textCleanUp(article.title!.rendered);

    // final Size size = MediaQuery.of(context).size;
    // ScreenUtil.init(context, designSize: size, allowFontScaling: true);

    return Text(
      title,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Theme.of(context).colorScheme.secondary,
        // fontFamily: 'Oswald',
        // fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.left,
    );
  }
}
