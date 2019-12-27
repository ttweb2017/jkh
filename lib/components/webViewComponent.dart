import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:halkbank_app/constants.dart';
import 'package:halkbank_app/screens/home/index.dart';

class WebViewComponent extends StatefulWidget {
  final String url;
  final Map<String, String> header;
  WebViewComponent({Key key, this.url, this.header}):super(key: key);

  @override
  _WebViewComponentState createState() => _WebViewComponentState(this.url);
}

class _WebViewComponentState extends State<WebViewComponent> {
  final String _url;
  final _key = UniqueKey();

  _WebViewComponentState(this._url);

  final flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {

    super.initState();

    flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if(url.contains(Constants.APP_URL + "/personal")){
        print("redirected: " + url);
        flutterWebViewPlugin.close();
        flutterWebViewPlugin.dispose();
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => HomeScreen(returnUrl: url)
            )
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    flutterWebViewPlugin.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        //leading: Icon(Icons.arrow_back_ios, color: Colors.white),
        middle: Text("Onlaýn Töleg", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[800],
      ),
      child: WebviewScaffold(
        key: _key,
        url: _url,
        withJavascript: true,
        withZoom: true,
        withLocalStorage: true,
        //hidden: true,
        initialChild: Container(
          color: Colors.green[800],
          child: const Center(
            child: Text('Ýüklenýär.....'),
          ),
        ),
      ),
    );
  }
}
