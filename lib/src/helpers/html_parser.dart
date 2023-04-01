import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart' as hp;
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';

import '../domain/schemas/schema.dart';
import '../screens/widgets/widgets.dart';

class HtmlParser extends StatefulWidget {
  final Post child;
  final num? fontSize;
  final String? fontFamily;

  const HtmlParser({
    Key? key,
    required this.child,
    this.fontSize,
    this.fontFamily,
  }) : super(key: key);

  @override
  _HtmlParserState createState() => _HtmlParserState();
}

class _HtmlParserState extends State<HtmlParser> {
  // final MyInAppBrowser browser = MyInAppBrowser();
  late Size size;
  int paras = 0;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    // ScreenUtil.init(context, designSize: size, allowFontScaling: true);

    List<String> paragraphs = widget.child.content!.rendered.split('<p>');

    for (var i = 0; i < paragraphs.length; i++) {
      paragraphs[i] = '<p>${paragraphs[i]}';
    }

    TextStyle textStyle = TextStyle(
      // fontFamily: widget.fontFamily,
      color: Theme.of(context).colorScheme.secondary.withOpacity(0.9),
      height: 1.5,
      fontSize: widget.fontSize?.toDouble() ?? 16,
    );

    return hp.HtmlWidget(
      widget.child.content!.rendered,
      onTapUrl: onTapUrl,
      onTapImage: (image) {
        launchUrl(
          Uri.parse(image.sources.single.url),
          mode: LaunchMode.inAppWebView,
        );
        // browser.openUrlRequest(
        //   urlRequest: URLRequest(
        //     url: Uri.parse(image.sources.single.url),
        //   ),
        //   options: kOPTIONS,
        // );
      },
      customWidgetBuilder: (dom.Element element) {
        // setState(() {
        paras++;
        // });
        for (int i = 0; i < paragraphs.length; i++) {
          paragraphs[i] = textCleanUp(paragraphs[i]);
        }

        return buildCustomWidget(element, paragraphs, textStyle);
      },
      textStyle: textStyle,
    );
  }

  FutureOr<bool> onTapUrl(String url) async {
    launchUrl(
      Uri.parse(url),
      mode: LaunchMode.inAppWebView,
    );
    return true;
  }

  Widget? buildCustomWidget(
      dom.Element element, List<String> paragraphs, TextStyle textStyle) {
    // int index = 0;
    debugPrint('\n\n\t\t $paras ');
    if (element.outerHtml.contains('<p>')) {
      //
      // for (int i = 0; i < paragraphs.length; i++) {
      //   debugPrint('\n\n\t\t $i ');
      //     debugPrint(
      //         '-\n\n\t\t $i\t${paragraphs[i]}\n\t\t${element.text}');
      //   if ((paragraphs[i]
      //       .contains(element.innerHtml)) /* && i % 4 == 0 && i != 0*/) {
      //     debugPrint('\n\n\t\t ****** $i TRUE');
      //     index = i;
      //   }
      // }
      // if (paragraphs[index].contains(element.innerHtml)) {
      return Column(
        children: [
          buildContent(element, textStyle),
          (paras % 4 == 0 && paras != 0)
              ? const CustomNativeAds(
                  isSmall:
                      false) //Container(color: cGrey, height: 50, width: double.infinity)
              : Container(),
        ],
      );
      // } else {
      //   return buildContent(element, textStyle);
      // }
    } else if (element.outerHtml.contains('wp-block-image')) {
      String temp = element.innerHtml.toString().split('src="')[1];
      String img = temp.split('"')[0];
      String caption = '';
      if (element.innerHtml.toString().contains('<figcaption>')) {
        String temp2 = element.innerHtml.toString().split('<figcaption>')[1];
        caption = '<figcaption>${temp2.split('</figcaption>')[0]}</figcaption>';
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: img,
              httpHeaders: const {"user-agent": kUserAgent},
              imageBuilder: (context, imageProvider) {
                return Image(image: imageProvider);
              },
              placeholder: (context, url) => Container(),
              errorWidget: (context, url, error) => Container(),
            ),
            hp.HtmlWidget(caption),
          ],
        ),
      );
    } else {
      return null;
    }
  }

  Padding buildContent(dom.Element element, TextStyle textStyle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: hp.HtmlWidget(
        element.outerHtml,
        textStyle: textStyle,
        onTapUrl: onTapUrl,
      ),
    );
  }
}
