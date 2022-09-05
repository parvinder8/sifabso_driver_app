import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sifabso_driver_app/navigation/navigation.dart';
import 'package:sifabso_driver_app/utils/shared_pref.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DriverWebView extends StatefulWidget {
  const DriverWebView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DriverWebViewState();
}

class _DriverWebViewState extends State<DriverWebView> {
  late WebViewController _controller;
  late Future<String> _future;
  String _mainUrl = "";

  Future<String> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _mainUrl = prefs.getString("main_url") ?? "";
    return Future.value(_mainUrl);
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = AndroidWebView();
    }
    _future = _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Text('none');
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
              return const Text('');
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text(
                  '${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                );
              } else {
                return SafeArea(
                  child: WillPopScope(
                    onWillPop: () => _goBack(context),
                    child: WebView(
                      onWebViewCreated: (controller) {
                        _controller = controller;
                      },
                      onPageStarted: (url) {
                        if (url.contains("mobile/mobile_logout") ||
                            url.contains("driver/driverlogout")) {
                          DriverSharedPreference().clearSharedPreference();
                          Navigation().navigateToHomeAndRemoveAll(context);
                        }
                      },
                      initialUrl: _mainUrl,
                      javascriptMode: JavascriptMode.unrestricted,
                      javascriptChannels: {
                        JavascriptChannel(
                            name: "getData",
                            onMessageReceived: (JavascriptMessage result) {}),
                      },
                    ),
                  ),
                );
              }
          }
        },
      ),
    );
  }

  Future<bool> _goBack(BuildContext context) async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return Future.value(false);
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text(
                  'Do you want to exit?',
                ),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      8.0,
                      12,
                      8,
                      12,
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(
                          const Size.fromWidth(
                            80,
                          ),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              40,
                            ),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('No'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 12, 8, 12),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all(
                              const Size.fromWidth(80)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)))),
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      child: const Text('Yes'),
                    ),
                  ),
                ],
              ));
      return Future.value(true);
    }
  }
}
