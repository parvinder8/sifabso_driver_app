import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:sifabso_driver_app/response/verify_driver_login.dart';
import 'package:sifabso_driver_app/utils/shared_pref.dart';

import '../navigation/navigation.dart';
import '../response/driver_login_response.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final OtpFieldController _otpFieldController = OtpFieldController();
  bool _isOtpCompleted = false;
  late Timer _timer;
  bool _loading = false;
  String _otp = "";
  bool _showResend = false;

  int start = 10;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, ((timer) {
      if (start == 0) {
        setState(() {
          _showResend = true;
          timer.cancel();
        });
      } else {
        setState(() {
          start--;
        });
      }
    }));
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  checkDriverLogin() async {
    final storeUrl = await DriverSharedPreference().getStoreUrl();
    final driverId = await DriverSharedPreference().getDriverId();
    var loginUrl = "$storeUrl/login";

    var response =
        await http.post(Uri.parse(loginUrl), body: {"mobile": driverId});

    setState(() {
      _loading = false;
      if (response.statusCode == 200) {
        var decodeJson = jsonDecode(response.body);
        var data = DriverLoginResponse.fromJson(decodeJson);
        if (data.status.toLowerCase().trim() == "success" &&
            data.type?.toLowerCase().trim() == "driver") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Otp Sent Again"),
            ),
          );
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

  checkOtp() async {
    var storeUrl = await DriverSharedPreference().getStoreUrl();
    final driverId = await DriverSharedPreference().getDriverId();
    final verifyDriverUrl = "$storeUrl/verifyDriverMobile";

    var response = await http.post(
      Uri.parse(verifyDriverUrl),
      body: {
        "mobile": driverId,
        "otp": _otp,
      },
    );
    setState(() {
      _loading = false;

      if (response.statusCode == 200) {
        var decodeJson = jsonDecode(response.body);
        var data = VerifyDriverResponse.fromJson(decodeJson);

        if (data.status.toLowerCase().trim() == "success") {
          DriverSharedPreference()
              .setMainUrl(storeUrl, Uri.encodeFull(driverId), data.token);
          DriverSharedPreference().setToken(data.token!);
          Navigation().navigateToWebScreenAndRemoveAll(context);
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(data.message!)));
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
        children: [
          Flexible(
            flex: 8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Enter OTP Here",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: OTPTextField(
                      controller: _otpFieldController,
                      width: MediaQuery.of(context).size.width - 200,
                      fieldWidth: 40.0,
                      fieldStyle: FieldStyle.box,
                      style: const TextStyle(fontSize: 18.0),
                      onChanged: (value) => {
                        if (value.length == 4)
                          {
                            setState(() {
                              _isOtpCompleted = true;
                              _otp = value;
                            })
                          }
                        else
                          {
                            setState((() {
                              _isOtpCompleted = false;
                            }))
                          }
                      },
                    ),
                  ),
                ),
                _showResend
                    ? TextButton(
                        onPressed: () {
                          setState(
                            () {
                              checkDriverLogin();
                              start = 60;
                              startTimer();
                              _showResend = false;
                            },
                          );
                        },
                        child: const Text(
                          "Resend Otp",
                        ),
                      )
                    : RichText(
                        text: TextSpan(
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                            children: [
                              const TextSpan(
                                text: "Resend otp in ",
                              ),
                              TextSpan(
                                  text: "$start ",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              const TextSpan(text: "sec "),
                            ]),
                      ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 40),
            child: _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all<Size>(
                        Size.fromWidth(
                          (MediaQuery.of(context).size.width - 100.0),
                        ),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                      ),
                    ),
                    onPressed: _isOtpCompleted
                        ? () {
                            setState(() {
                              _loading = true;
                            });
                            checkOtp();
                          }
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Enter Otp First"),
                              ),
                            );
                          },
                    child: const Text("Proceed"),
                  ),
          ),
        ],
      ),
    );
  }
}
