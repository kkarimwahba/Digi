// import 'package:digi2/screens/onboarding/onboarding_contents.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class WebViewContainer extends StatefulWidget {
//   const WebViewContainer({super.key});
//   @override
//   State<WebViewContainer> createState() => _WebViewContainerState();
// }

// class _WebViewContainerState extends State<WebViewContainer> {
//   final WebViewController _controller = WebViewController();
//   String pageTitle = "-";
//   double progress = 0;
//   @override
//   void initState() {
//     super.initState();
//     _controller
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..loadRequest(Uri.parse('https://youtube.com'));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//           body: Column(
//         children: [Expanded(child: WebViewWidget(controller: _controller))],
//       )),
//     ); // Scaffold
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LocalWebPage extends StatefulWidget {
  const LocalWebPage({super.key});

  @override
  _LocalWebPageState createState() => _LocalWebPageState();
}

class _LocalWebPageState extends State<LocalWebPage> {
  final WebViewController _controller = WebViewController();
  String pageTitle = "-";
  double progress = 0;

  @override
  void initState() {
    super.initState();
    _loadLocalWebPage();
  }

  Future<void> _loadLocalWebPage() async {
    final htmlString = await _getHtmlString();
    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(htmlString);
  }

  Future<String> _getHtmlString() async {
    final String htmlString =
        await rootBundle.loadString('assets/web/page.html');
    return htmlString;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [Expanded(child: WebViewWidget(controller: _controller))],
      )),
    );
  }
}
