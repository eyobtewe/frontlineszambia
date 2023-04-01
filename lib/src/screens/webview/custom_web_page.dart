// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// class CustomWebPage extends StatefulWidget {
//   final String url;
//   final String? title;

//   const CustomWebPage({Key? key, required this.url, this.title})
//       : super(key: key);

//   @override
//   _CustomWebPageState createState() => _CustomWebPageState();
// }

// class _CustomWebPageState extends State<CustomWebPage> {
//   late InAppWebViewController webView;
//   // String url = "";
//   double progress = 0;

//   bool isLoading = false;
//   double height = 10;

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     // showToast('Loading...');

//     return SafeArea(
//       child: Scaffold(
//         // appBar: AppBar(
//         //   // backgroundColor: cTransparent,
//         //   iconTheme: IconThemeData(color: cBlack),
//         //   elevation: height,
//         //   toolbarHeight: 48,
//         // ),
//         floatingActionButton: FloatingActionButton(
//           child: const Icon(Icons.arrow_back),
//           backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         body: Stack(
//           fit: StackFit.expand,
//           children: [
//             InAppWebView(
//               initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
//               initialOptions: InAppWebViewGroupOptions(
//                 crossPlatform: InAppWebViewOptions(),
//               ),
//               onWebViewCreated: (InAppWebViewController controller) {
//                 webView = controller;
//               },
//               onProgressChanged: (InAppWebViewController controller, int pro) {
//                 setState(() {
//                   progress = pro / 100;
//                   if (progress == 100) {
//                     height = 0;
//                   }
//                 });
//               },
//             ),
//             progress < 1.0
//                 ? Positioned(
//                     child: LinearProgressIndicator(
//                       value: progress,
//                       backgroundColor: Theme.of(context)
//                           .scaffoldBackgroundColor
//                           .withOpacity(0.25),
//                       valueColor: AlwaysStoppedAnimation<Color>(
//                           Theme.of(context).scaffoldBackgroundColor),
//                     ),
//                     bottom: 0,
//                     width: size.width,
//                   )
//                 : Container(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class MyInAppBrowser extends InAppBrowser {
//   @override
//   Future onBrowserCreated() async {
//     debugPrint("Browser Created!");
//   }

//   @override
//   Future onLoadStart(url) async {
//     debugPrint("Started $url");
//   }

//   @override
//   Future onLoadStop(url) async {
//     debugPrint("Stopped $url");
//   }

//   @override
//   void onLoadError(url, code, message) {
//     debugPrint("Can't load $url.. Error: $message");
//   }

//   @override
//   void onProgressChanged(progress) {
//     debugPrint("Progress: $progress");
//   }

//   @override
//   void onExit() {
//     debugPrint("Browser closed!");
//   }
// }

// final InAppBrowserClassOptions kOPTIONS = InAppBrowserClassOptions(
//   crossPlatform: InAppBrowserOptions(
//     hideUrlBar: false,
//     // toolbarTopBackgroundColor: cPrimaryColor,
//   ),
//   inAppWebViewGroupOptions: InAppWebViewGroupOptions(
//     android: AndroidInAppWebViewOptions(),
//     crossPlatform: InAppWebViewOptions(
//       javaScriptEnabled: true,
//     ),
//   ),
// );
