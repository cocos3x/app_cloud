import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// WKWebView + callback giống WccHost.Boot / OpenLink / ShowPane.
class TideHarborWebView extends StatefulWidget {
  const TideHarborWebView({
    super.key,
    required this.url,
    this.enableWKWebView = true,
  });

  final String url;
  final bool enableWKWebView;

  @override
  State<TideHarborWebView> createState() => _TideHarborWebViewState();
}

class _TideHarborWebViewState extends State<TideHarborWebView> {
  late final WebViewController _controller;
  bool _paneVisible = false;

  @override
  void initState() {
    super.initState();
    _boot();
  }

  void _boot() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..addJavaScriptChannel(
        'unityControl',
        onMessageReceived: (message) => _onJsPing(message.message),
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: _onStarted,
          onPageFinished: _onLoaded,
          onWebResourceError: (error) {
            final failedUrl = error.url ?? '';
            final failedUri = Uri.tryParse(failedUrl);
            if (failedUri?.scheme == 'tg') {
              _openTelegram(failedUri!);
            }
          },
          onNavigationRequest: (request) {
            final uri = Uri.tryParse(request.url);
            if (uri == null) return NavigationDecision.prevent;
            if (uri.scheme == 'tg') {
              _openTelegram(uri);
              return NavigationDecision.prevent;
            }
            if (uri.scheme == 'http' || uri.scheme == 'https') {
              return NavigationDecision.navigate;
            }
            _openExternal(request.url);
            return NavigationDecision.prevent;
          },
        ),
      );
    _openLink(widget.url);
  }

  Future<void> _injectUnityBridge() {
    return _controller.runJavaScript('''
      (function() {
        if (window.Unity && window.Unity.call) return;
        window.Unity = {
          call: function(msg) {
            try { unityControl.postMessage(String(msg)); } catch (e) {}
          }
        };
      })();
    ''');
  }

  void _onJsPing(String msg) {
    _openExternal(msg);
  }

  void _onStarted(String msg) {
    _injectUnityBridge();
  }

  void _onLoaded(String msg) {
    _injectUnityBridge();
    _showPane(true);
  }

  void _showPane(bool visible) {
    if (!mounted || _paneVisible == visible) return;
    setState(() => _paneVisible = visible);
  }

  void _openLink(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || url.isEmpty) return;
    _controller.loadRequest(uri);
    _showPane(true);
  }

  Future<void> _openTelegram(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openExternal(String msg) async {
    final uri = Uri.tryParse(msg.trim());
    if (uri == null || uri.scheme.isEmpty) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: Opacity(
        opacity: _paneVisible ? 1 : 0,
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
