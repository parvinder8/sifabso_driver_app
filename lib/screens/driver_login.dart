import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sifabso_driver_app/response/driver_login_response.dart';
import 'package:sifabso_driver_app/utils/shared_pref.dart';

import '../navigation/navigation.dart';

class DriverLoginPage extends StatefulWidget {
  const DriverLoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DriverLoginPage();
}

class _DriverLoginPage extends State<DriverLoginPage> {
  final _loginController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _loginController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _loginController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  void checkDriverLogin() async {
    var storeUrl = await DriverSharedPreference().getStoreUrl();
    var loginUrl = "$storeUrl/login";

    var response = await http
        .post(Uri.parse(loginUrl), body: {"mobile": _loginController.text});

    setState(() {
      _loading = false;
      if (response.statusCode == 200) {
        var decodeJson = jsonDecode(response.body);
        var data = DriverLoginResponse.fromJson(decodeJson);
        if (data.status.toLowerCase().trim() == "success" &&
            data.type?.toLowerCase().trim() == "driver") {
          DriverSharedPreference().setDriverId(_loginController.text);
          Navigation().navigateToOtpScreen(context);
        } else if (data.status.toLowerCase().trim() == "success" &&
            data.type?.toLowerCase().trim() != "driver") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Enter A Valid Driver Id"),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data.message.toString())),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Server Error",
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(
                    8.0,
                    0,
                    0,
                    40.0,
                  ),
                  child: Image(
                    height: 120.0,
                    image: AssetImage(
                      "assets/images/driver.png",
                    ),
                  ),
                ),
                const Text(
                  "Login with Email or Phone Number",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(
                    16.0,
                  ),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      focusColor: Colors.orange,
                      filled: _loginController.text.isEmpty ? true : false,
                      fillColor: const Color.fromRGBO(245, 245, 245, 1),
                      hintText: "Enter Mobile Number Or Email",
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            12.0,
                          ),
                        ),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    controller: _loginController,
                  ),
                ),
                _loading
                    ? const CircularProgressIndicator()
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(
                          0,
                          16,
                          0,
                          0,
                        ),
                        child: MaterialButton(
                          padding: const EdgeInsets.fromLTRB(
                            50,
                            12,
                            50,
                            12,
                          ),
                          onPressed: _loginController.text.isNotEmpty
                              ? () {
                                  setState(() {
                                    _loading = true;
                                  });
                                  checkDriverLogin();
                                }
                              : () {
                                  var scaffold = ScaffoldMessenger.of(context);
                                  scaffold.showSnackBar(SnackBar(
                                    content: const Text("Enter Phone Number"),
                                    action: SnackBarAction(
                                      label: "OK",
                                      onPressed: scaffold.hideCurrentSnackBar,
                                    ),
                                  ));
                                },
                          elevation: 5,
                          shape: const RoundedRectangleBorder(
                            side: BorderSide(
                              style: BorderStyle.solid,
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                12.0,
                              ),
                            ),
                          ),
                          color: _loginController.text.isEmpty
                              ? const Color.fromRGBO(245, 245, 245, 1)
                              : Colors.orange,
                          child: const Text(
                            "Submit",
                          ),
                        ),
                      )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Powered By ",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 8,
                ),
              ),
              Text(
                "Sifabso",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
