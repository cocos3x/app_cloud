import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'tide_harbor_web_view.dart';

/// Bản cloud: WebView full màn hình. Chỉ mount khi đã có link (is_active=true).
class LiveWebPage extends StatefulWidget {
  const LiveWebPage({super.key, required this.url});

  final String url;

  @override
  State<LiveWebPage> createState() => _LiveWebPageState();
}

class _LiveWebPageState extends State<LiveWebPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: TideHarborWebView(key: ValueKey(widget.url), url: widget.url),
    );
  }
}
