import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VoteWebView extends StatefulWidget {
  const VoteWebView({
    super.key,
  });

  @override
  State<VoteWebView> createState() => _VoteWebViewState();
}

class _VoteWebViewState extends State<VoteWebView> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse('https://ggugitt.com/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox.expand(
          child: WebViewWidget(
            controller: controller,
          ),
        ),
      ),
    );
  }
}
