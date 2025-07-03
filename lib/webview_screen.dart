import 'package:flutter/material.dart';
import 'package:sanaa/CommonFiles/image_file.dart';
import 'package:sanaa/Navigation/navigation_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String url;

  const WebViewScreen({Key? key, required this.url}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _webViewController;
  double progress = 0;

  @override
  void initState() {
    super.initState();
    // Initialize the WebViewController
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000)) // Transparent background
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              this.progress = progress / 100;
            });
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: $error');
          },
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url.toLowerCase();
            if (url.contains('success')) {
              // Handle success case
              debugPrint('Success URL detected: $url');
              // Example action: Show a snackbar
              NavigationService.navigateTo('/orderConfirmScreen');
              // Optionally prevent navigation or redirect
              return NavigationDecision.prevent;
            } else if (url.contains('failure')) {
              // Handle failure case
              debugPrint('Failure URL detected: $url');
              // Example action: Show a snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payment or action failed!')),
              );
              // Optionally prevent navigation or redirect
               return NavigationDecision.prevent;
            }else {
              return NavigationDecision.navigate;
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url.startsWith('http')
          ? widget.url
          : 'https://${widget.url}'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: Padding(padding: EdgeInsets.all(8), child: InkWell(onTap: (){
        NavigationService.goBack();
      }, child: Image.asset(back))),),
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: _webViewController),
            if (progress < 1.0)
              LinearProgressIndicator(value: progress),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _webViewController
      ..loadRequest(Uri.parse('about:blank')) // Load a blank page to stop current activity
      ..clearCache() // Clear cache to prevent lingering requests
      ..clearLocalStorage();
  }
}