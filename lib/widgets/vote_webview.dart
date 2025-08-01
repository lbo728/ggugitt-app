import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/env_config.dart';

class VoteWebView extends StatefulWidget {
  const VoteWebView({
    super.key,
  });

  @override
  State<VoteWebView> createState() => _VoteWebViewState();
}

class _VoteWebViewState extends State<VoteWebView> {
  WebViewController? controller;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView progress: $progress%');
          },
          onPageStarted: (String url) {
            debugPrint('WebView started loading: $url');
            if (mounted) {
              setState(() {
                isLoading = true;
                errorMessage = null;
              });
            }
          },
          onPageFinished: (String url) {
            debugPrint('WebView finished loading: $url');
            if (mounted) {
              setState(() {
                isLoading = false;
                errorMessage = null;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: ${error.description}');
            if (mounted) {
              setState(() {
                errorMessage = error.description;
                isLoading = false;
              });
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            debugPrint('Navigation request: ${request.url}');

            // 카카오톡 링크나 기타 커스텀 스키마 처리
            if (request.url.startsWith('kakaolink://') ||
                request.url.startsWith('kakao://') ||
                request.url.startsWith('tel:') ||
                request.url.startsWith('mailto:') ||
                request.url.startsWith('sms:')) {
              _launchExternalUrl(request.url);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'Flutter',
        onMessageReceived: (JavaScriptMessage message) {
          debugPrint('JavaScript message: ${message.message}');
        },
      )
      ..loadRequest(Uri.parse(EnvConfig.baseUrl));
  }

  Future<void> _launchExternalUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // 앱이 설치되지 않은 경우 사용자에게 알림
        if (mounted) {
          _showAppNotInstalledDialog(url);
        }
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      if (mounted) {
        _showAppNotInstalledDialog(url);
      }
    }
  }

  void _showAppNotInstalledDialog(String url) {
    String appName = '앱';
    String message = '해당 앱을 찾을 수 없습니다.';

    if (url.startsWith('kakaolink://') || url.startsWith('kakao://')) {
      appName = '카카오톡';
      message = '카카오톡 앱이 설치되어 있지 않습니다.';
    } else if (url.startsWith('tel:')) {
      appName = '전화';
      message = '전화 기능을 사용할 수 없습니다.';
    } else if (url.startsWith('mailto:')) {
      appName = '메일';
      message = '메일 앱을 찾을 수 없습니다.';
    } else if (url.startsWith('sms:')) {
      appName = '문자';
      message = '문자 앱을 찾을 수 없습니다.';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$appName 앱 없음'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _reloadWebView() {
    if (controller != null) {
      controller!.reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox.expand(
              child: WebViewWidget(
                controller: controller!,
              ),
            ),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
            if (errorMessage != null)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '로딩 중 오류가 발생했습니다',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      errorMessage!,
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _reloadWebView,
                      child: const Text('다시 시도'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
