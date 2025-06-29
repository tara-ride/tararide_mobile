import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PassengerPayment extends StatefulWidget {
  final String checkoutURL;

  const PassengerPayment({super.key, required this.checkoutURL});

  @override
  State<StatefulWidget> createState() => PassengerPaymentState();
}

class PassengerPaymentState extends State<PassengerPayment> {
  late final WebViewController webViewController;

  @override
  void initState() {
    super.initState();
    webViewController = WebViewController()
      ..loadRequest(Uri.parse(widget.checkoutURL))
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
          child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: WebViewWidget(controller: webViewController),
      )),
    );
  }
}
