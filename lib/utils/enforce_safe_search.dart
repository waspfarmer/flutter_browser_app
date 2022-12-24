import 'package:flutter_inappwebview/flutter_inappwebview.dart';

WebUri? updateWithSafeSearch(WebUri uri) {
  String uriStr = uri.toString();
  if (RegExp(r'bing\..*(\/search|\/videos|\/images|\/news)')
      .hasMatch(uri.toString())) {
    return _metaAdd(uri, {"adlt": "strict"});
  } else if (RegExp(r'duckduckgo\..*q=').hasMatch(uriStr)) {
    return _metaAdd(uri, {"kp": "1"});
  } else if (RegExp(r'ecosia.*search').hasMatch(uriStr)) {
    return _metaAdd(uri, {"safesearch": "2"});
  } else if (RegExp(r'google.*(webhp|search).*q=').hasMatch(uriStr)) {
    return _metaAdd(uri, {"safe": "on"});
  } else if (RegExp(r'qwant.com').hasMatch(uriStr)) {
    // seems to not be heeded
    return _metaAdd(uri, {"safesearch": "2", "s": "2"});
  } else if (RegExp(r'search.yahoo.*\/search').hasMatch(uriStr)) {
    return _metaAdd(uri, {"vm": "r"});
  } else if (RegExp(r'yandex\..*\/search').hasMatch(uriStr)) {
    return _metaAdd(uri, {"fyandex": "1"});
  } else if (RegExp(r'onesearch.*\/search').hasMatch(uriStr)) {
    return _metaAdd(uri, {"vm": "r"});
  }

  return null;
}

WebUri? _metaAdd(WebUri uri, Map<String, dynamic> queryParameters) {
  Map<String, dynamic> params =
  Map<String, dynamic>.from(uri.queryParameters); // query parameters automatically populated

  bool remainsUnchanged = true;

  queryParameters.forEach((key, value) {
    if (!params.containsKey(key) || params[key] != value) {
      remainsUnchanged = false;
    }

    params[key] = value;
  });

  if (remainsUnchanged) return null;

  Uri outgoingUri =
  Uri(scheme: uri.scheme, host: uri.host, path: uri.path, queryParameters: params);

  return WebUri(outgoingUri.toString());
}