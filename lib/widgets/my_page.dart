import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyPage extends StatelessWidget {
  const MyPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
              ),
              const Text(
                '마이페이지',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Expanded(
                child: Column(
                  children: [
                    _buildMenuItem(
                      context,
                      icon: Icons.person,
                      title: '프로필 설정',
                      onTap: () {
                        // 프로필 설정 기능
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    // _buildMenuItem(
                    //   context,
                    //   icon: Icons.notifications,
                    //   title: '알림 설정',
                    //   onTap: () {
                    //     // 알림 설정 기능
                    //   },
                    // ),
                    // const SizedBox(
                    //   height: 16,
                    // ),
                    _buildMenuItem(
                      context,
                      icon: Icons.privacy_tip,
                      title: '개인정보 처리방침',
                      onTap: () {
                        // 개인정보 처리방침 보기
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    // _buildMenuItem(
                    //   context,
                    //   icon: Icons.help,
                    //   title: '도움말',
                    //   onTap: () {
                    //     // 도움말 보기
                    //   },
                    // ),
                    // const Spacer(),
                    _buildDeleteAccountButton(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.black,
                  size: 24,
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteAccountButton(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showDeleteAccountDialog(context),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  Icons.delete_forever,
                  color: Colors.red[600],
                  size: 24,
                ),
                const SizedBox(width: 16),
                Text(
                  '계정 삭제',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.red[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('계정 삭제'),
          content: const Text(
            '정말로 계정을 삭제하시겠습니까?\n\n삭제된 계정은 복구할 수 없으며, 모든 데이터가 영구적으로 삭제됩니다.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAccount(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('삭제'),
            ),
          ],
        );
      },
    );
  }

  void _deleteAccount(BuildContext context) {
    // 계정 삭제 로직 구현
    // 여기서는 웹뷰를 통해 계정 삭제 페이지로 이동
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AccountDeletionWebView(),
      ),
    );
  }
}

class AccountDeletionWebView extends StatefulWidget {
  const AccountDeletionWebView({super.key});

  @override
  State<AccountDeletionWebView> createState() => _AccountDeletionWebViewState();
}

class _AccountDeletionWebViewState extends State<AccountDeletionWebView> {
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
      ..loadRequest(Uri.parse('https://ggugitt.com/account/delete'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('계정 삭제'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SizedBox.expand(
            child: WebViewWidget(
              controller: controller,
            ),
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
