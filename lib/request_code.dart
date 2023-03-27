import 'dart:async';
import 'package:flutter/material.dart';

import 'request/authorization_request.dart';
import 'model/config.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RequestCode {
  final Config _config;
  final AuthorizationRequest _authorizationRequest;

  String? _code;

  RequestCode(Config config)
      : _config = config,
        _authorizationRequest = AuthorizationRequest(config);

  Future<String?> requestCode() async {
    _code = null;
    final urlParams = _constructUrlParams();

    var webViewController = WebViewController();

    await webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);
    await webViewController.setBackgroundColor(Colors.transparent);
    await webViewController.setNavigationDelegate(NavigationDelegate(onNavigationRequest: _navigationDelegate));
    await webViewController.loadRequest(Uri.parse('${_authorizationRequest.url}?$urlParams'));

    var webView = WebViewWidget(controller: webViewController);

    await _config.navigatorState!.push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
            body: SafeArea(
          child: Stack(
            children: [_config.loader, webView],
          ),
        )),
      ),
    );
    return _code;
  }

  FutureOr<NavigationDecision> _navigationDelegate(NavigationRequest request) {
    var uri = Uri.parse(request.url);

    if (uri.queryParameters['error'] != null) {
      _config.navigatorState!.pop();
    }

    if (uri.queryParameters['code'] != null) {
      _code = uri.queryParameters['code'];
      _config.navigatorState!.pop();
    }
    return NavigationDecision.navigate;
  }

  Future<void> clearCookies() async {
    await WebViewCookieManager().clearCookies();
  }

  String _constructUrlParams() => _mapToQueryParams(_authorizationRequest.parameters);

  String _mapToQueryParams(Map<String, String> params) {
    final queryParams = <String>[];
    params.forEach((String key, String value) => queryParams.add('$key=${Uri.encodeQueryComponent(value)}'));
    return queryParams.join('&');
  }
}
