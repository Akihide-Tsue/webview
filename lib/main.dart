import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// エントリポイント
void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const WebViewApp(),
    ),
  );
}

/// WebViewアプリの状態を持つStatefulWidget
class WebViewApp extends StatefulWidget {
  /// WebViewAppのコンストラクタ
  const WebViewApp({super.key});

  /// 状態オブジェクトを作成
  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

/// WebViewAppの状態を管理するStateクラス
class _WebViewAppState extends State<WebViewApp> {
  /// WebViewControllerオブジェクト
  late final WebViewController controller;

  /// 初期状態を設定
  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) async {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..setUserAgent("ユーザーエージェント変更：webview-from-flutter-app")
      ..loadRequest(
        Uri.parse('http://localhost:3000/'),
      );
  }

  /// アプリのUIを構築
  late final WebViewController _controller;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ここにタイトル'),
        leading: _buildProfileIconButton(),
      ),
      body: Column(
        children: [
          if (_isLoading) const LinearProgressIndicator(),
          Expanded(
            child: WebViewWidget(controller: _controller),
          ),
          // Container(
          //   color: Colors.lightBlue,
          //   child: SafeArea(
          //     child: Row(
          //       children: [
          //         IconButton(
          //           icon: const Icon(
          //             Icons.arrow_back,
          //           ),
          //           color: Colors.white,
          //           onPressed: () async {
          //             _controller.goBack();
          //           },
          //         ),
          //         IconButton(
          //           icon: const Icon(
          //             Icons.arrow_forward,
          //           ),
          //           color: Colors.white,
          //           onPressed: () async {
          //             _controller.goForward();
          //           },
          //         ),
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  Widget _buildProfileIconButton() {
    const iconSize = 32.0;
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        size: iconSize,
      ),
      // onPressed: () => print('中身'));
      onPressed: () async {
        _controller.goBack();
      },
    );
  }
}
