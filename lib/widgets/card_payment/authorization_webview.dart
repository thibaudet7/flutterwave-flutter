import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterwave/utils/flutterwave_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AuthorizationWebview extends StatefulWidget {
  final String _url;

  AuthorizationWebview(this._url);

  @override
  _AuthorizationWebviewState createState() => _AuthorizationWebviewState();
}

class _AuthorizationWebviewState extends State<AuthorizationWebview> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: WebView(
            initialUrl: this.widget._url,
            javascriptMode: JavascriptMode.unrestricted,
            onPageStarted: this._pageStarted,
          ),
        ),
      ),
    );
  }

  void _pageStarted(String url) {
    final bool startsWithMyRedirectUrl = url
            .toString()
            .indexOf(FlutterwaveUtils.DEFAULT_REDIRECT_URL.toString()) ==
        0;
    if (url != this.widget._url && startsWithMyRedirectUrl) {
      this._onValidationSuccessful(url);
      return;
    }
    print("startsWithMyRedirectUrl $startsWithMyRedirectUrl");
  }

  void _onValidationSuccessful(String url) {
    var response = Uri.dataFromString(url).queryParameters["response"];
    var resp = Uri.dataFromString(url).queryParameters["resp"];
    if (response != null) {
      final String responseString = Uri.decodeFull(response);
      final Map data = json.decode(responseString);
      print("response from weview is $responseString");
      if (data["status"] != null && data["status"] == "successful") {
        final String flwRef = data["flwRef"];
        Navigator.pop(this.context, flwRef);
      } else {
        final String errorMessage = data["message"] != null
            ? data["message"]
            : "Unable to complete transaction";
        Navigator.pop(this.context, {"error": errorMessage});
      }
      return;
    }
    if (resp != null) {
      final String responseString = Uri.decodeFull(resp);
      final Map map = json.decode(responseString);
      if (map["status"] == "success") {
        final String flwRef = map["data"]["flwRef"];
        Navigator.pop(this.context, flwRef);
        return;
      }
      Navigator.pop(this.context, {"error": map["message"]});
      return;
    }
    print("resp and response are null");
    return;
  }
}
