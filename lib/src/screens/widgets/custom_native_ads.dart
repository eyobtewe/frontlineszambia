import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:native_admob_flutter/native_admob_flutter.dart';

class CustomNativeAds extends StatefulWidget {
  const CustomNativeAds({Key? key, this.isSmall = true}) : super(key: key);
  final bool isSmall;

  @override
  _CustomNativeAdsState createState() => _CustomNativeAdsState();
}

class _CustomNativeAdsState extends State<CustomNativeAds>
    with AutomaticKeepAliveClientMixin {
  final controller = NativeAdController();

  @override
  void initState() {
    super.initState();

    controller.load(unitId: widget.isSmall ? smallAd : bigAd);

    controller.onEvent.listen(
      (Map<NativeAdEvent, dynamic> event) {
        if (event.keys.first == NativeAdEvent.loaded) {
          setState(() {});
        } else if (event.keys.first == NativeAdEvent.loadFailed) {
          debugPrint(
              '----------\n\n\n\t\t\t ad failed\n\n\n\n\n\n-------------');
        }
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final textStyle2 = TextStyle(
      fontFamily: 'OpenSans',
      color: Theme.of(context).scaffoldBackgroundColor,
    );

    return !controller.isLoaded
        ? Container()
        : (widget.isSmall)
            ? buildSmallAd(context, textStyle2)
            : buildBigAd(context, textStyle2);
  }

  NativeAd buildBigAd(BuildContext context, TextStyle textStyle2) {
    return NativeAd(
      controller: controller,
      height: 345,
      builder: (_, child) {
        return Material(child: child);
      },
      buildLayout: _buildBigAdLayout,
      icon: AdImageView(size: 40),
      loading: const Center(child: CupertinoActivityIndicator()),
      error: const Center(child: Text('ERROR')),
      headline: adHeadline(context),
      button: adBigBtn(context, textStyle2),
      advertiser: adAdvertiser(textStyle2),
      body: adBody(context),
      media: adBigMedia(),
      attribution: adAttribution(context, textStyle2),
    );
  }

  AdMediaView adBigMedia() {
    return AdMediaView(
      height: 170,
      width: MATCH_PARENT,
      margin: const EdgeInsets.symmetric(vertical: 5),
    );
  }

  AdButtonView adBigBtn(BuildContext context, TextStyle textStyle2) {
    return AdButtonView(
      decoration: AdDecoration(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        borderRadius: AdBorderRadius.all(15),
      ),
      textStyle: textStyle2,
      height: MATCH_PARENT,
    );
  }

  AdLayoutBuilder get _buildBigAdLayout {
    return (_, media, icon, headline, advertiser, body, price, store,
        attribution, button) {
      return AdLinearLayout(
        decoration: AdDecoration(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        width: MATCH_PARENT,
        height: MATCH_PARENT,
        gravity: LayoutGravity.center_vertical,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        children: [
          attribution,
          AdLinearLayout(
            padding: const EdgeInsets.only(top: 6.0),
            height: WRAP_CONTENT,
            orientation: HORIZONTAL,
            children: [
              icon,
              AdExpanded(
                flex: 2,
                child: AdLinearLayout(
                  width: WRAP_CONTENT,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  children: [headline, advertiser, body],
                ),
              ),
            ],
          ),
          media,
          button
        ],
      );
    };
  }

  NativeAd buildSmallAd(BuildContext context, TextStyle textStyle2) {
    return NativeAd(
      controller: controller,

      loading: const Center(child: CupertinoActivityIndicator()),
      error: const Center(child: Text('ERROR')),
      media: AdMediaView(
          decoration: AdDecoration(
        borderRadius: AdBorderRadius.all(15),
      )),
      attribution: adAttribution(context, textStyle2),
      button: adBtnView(context, textStyle2),
      advertiser: adAdvertiser(textStyle2),
      // body: adBody(context),
      headline: adHeadline(context),
      height: 115,
      builder: (_, child) => Material(child: child),
      buildLayout: _buildSmallAdLayout,
    );
  }

  AdLayoutBuilder get _buildSmallAdLayout {
    return (_, media, icon, headline, advertiser, body, price, store,
        attribution, button) {
      return AdLinearLayout(
        decoration: AdDecoration(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        width: MATCH_PARENT,
        orientation: HORIZONTAL,
        height: MATCH_PARENT,
        gravity: LayoutGravity.center_vertical,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        children: [
          AdExpanded(
            flex: 4,
            child: AdLinearLayout(
              padding: const EdgeInsets.only(right: 10),
              height: WRAP_CONTENT,
              orientation: VERTICAL,
              children: [headline, advertiser, button],
            ),
          ),
          AdExpanded(
            flex: 7,
            child: AdLinearLayout(
              orientation: VERTICAL,
              children: [attribution, media],
            ),
          ),
        ],
      );
    };
  }

  AdTextView adAdvertiser(TextStyle textStyle2) => AdTextView(
      maxLines: 1,
      style: TextStyle(
        color: Theme.of(context).colorScheme.secondary,
      ));

  AdTextView adHeadline(BuildContext context) {
    return AdTextView(
      maxLines: 3,
      style: TextStyle(
        color: Theme.of(context).colorScheme.secondary,
        fontFamily: 'OpenSans',
        fontWeight: FontWeight.bold,
      ),
    );
  }

  AdTextView adBody(BuildContext context) {
    return AdTextView(
      maxLines: 2,
      style: TextStyle(
        color: Theme.of(context).colorScheme.secondary,
        fontFamily: 'OpenSans',
      ),
    );
  }

  AdTextView adAttribution(BuildContext context, TextStyle textStyle2) {
    return AdTextView(
      decoration: AdDecoration(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        borderRadius: AdBorderRadius.all(10),
      ),
      width: 22,
      style: textStyle2,
    );
  }

  AdButtonView adBtnView(BuildContext context, TextStyle textStyle2) {
    return AdButtonView(
      decoration: AdDecoration(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        borderRadius: AdBorderRadius.all(15),
      ),
      textStyle: textStyle2,
    );
  }

  @override
  bool get wantKeepAlive => true;
}

const String smallAd = 'ca-app-pub-7392401392723371/4965764915';
const String bigAd = 'ca-app-pub-7392401392723371/1395498649';
