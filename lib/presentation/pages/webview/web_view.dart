import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DefaultWebView extends StatefulWidget {
  final String url;
  const DefaultWebView({Key? key, required this.url}) : super(key: key);

  @override
  State<DefaultWebView> createState() => _DefaultWebViewState();
}

class _DefaultWebViewState extends State<DefaultWebView> {
  final WebViewController _controller = WebViewController();
  String? errorMsg;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then((_) async {
      try {
        _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
        await _controller.loadRequest(Uri.parse(widget.url));
      } catch (e) {
        Logger.e(e);
        setState(() {
          errorMsg = "Cannot load the page.";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (errorMsg != null) {
      return Center(
        child: Text(errorMsg!),
      );
    }
    return WebViewWidget(controller: _controller);
  }
}
