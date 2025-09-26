import 'package:fardinexpress/features/app/extend_app_logistic/feature/blog/models/info.dart';
import 'package:fardinexpress/utils/bloc/indexing/indexing_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:webview_flutter_plus/webview_flutter_plus.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// ignore: import_of_legacy_library_into_null_safe
// import 'package:webview_flutter/webview_flutter.dart';

// import 'package:webview_flutter_plus/webview_flutter_plus.dart';
class InfoDetailPageWrapper extends StatefulWidget {
  final Info info;
  InfoDetailPageWrapper({required this.info});

  @override
  _InfoDetailPageWrapperState createState() => _InfoDetailPageWrapperState();
}

class _InfoDetailPageWrapperState extends State<InfoDetailPageWrapper> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InfoDetailPage(
      info: widget.info,
    );
  }
}

class InfoDetailPage extends StatefulWidget {
  final Info info;
  InfoDetailPage({required this.info});

  @override
  _InfoDetailPageState createState() => _InfoDetailPageState();
}

class _InfoDetailPageState extends State<InfoDetailPage> {
  IndexingBloc indexingBloc = IndexingBloc();
  //late WebViewController _webViewController;
  // late WebViewControllerPlus _controller;

  // InAppWebViewController? webViewController;
  InAppWebViewSettings options = InAppWebViewSettings(
    mediaPlaybackRequiresUserGesture: false,
    javaScriptCanOpenWindowsAutomatically: true,
    javaScriptEnabled: true,
    supportZoom: false,
    useWideViewPort: true,
    displayZoomControls: false,
    domStorageEnabled: true,
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    indexingBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back_ios_outlined),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(widget.info.title),
      ),
      body:
          // Container()
          // WebViewWidget(
          //   controller: _controller,
          // )

          // WebViewPlus(
          //   javascriptMode: JavascriptMode.unrestricted,
          //   onWebViewCreated: (controller) {
          //     // controller.loadUrl('https://flutter.dev/');
          //     controller.loadUrl(widget.info.link);
          //   },
          //   initialUrl: widget.info.link,
          //   onWebResourceError: (error) {
          //     print("WebView error: $error");
          //     // Handle error, e.g., show an error message to the user
          //   },
          // )

          InAppWebView(
              // key: webViewKey,
              initialUrlRequest: URLRequest(
                  url: WebUri(widget.info.link
                      // 'https://maps.app.goo.gl/JsnffHYfE4yPmdkR8'
                      )),
              initialSettings: options,
              onWebViewCreated: (controller) async {},
              onLoadStop: (controller, url) async {
                print('onLoadStop..: $url');
              },
              onLoadStart: (controller, url) async {
                print('onLoadStart..: $url');
              },
              onPermissionRequest: (controller, request) async {
                return PermissionResponse(
                    resources: request.resources,
                    action: PermissionResponseAction.GRANT);
              }),
    );
  }
}
