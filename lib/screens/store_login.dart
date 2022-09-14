import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:turns_fleet/utils/shared_pref.dart';

import '../navigation/navigation.dart';

class StoreLoginPage extends StatefulWidget {
  const StoreLoginPage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StoreLoginPage();
}

class _StoreLoginPage extends State<StoreLoginPage> {
  bool _loading = false;
  final _storeController = TextEditingController();

  @override
  void initState() {
    _storeController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _storeController.dispose();
    super.dispose();
  }

  void checkStoreName() async {
    var storeName = _storeController.text.trim().toLowerCase();
    var baseUrl = "https://$storeName.sifabso.com/flutter";
    var mainUrl = "$baseUrl/index";

    var response = await http.get(Uri.parse(mainUrl));
    setState(() {
      _loading = false;

      if (response.statusCode == 200) {
        DriverSharedPreference().setStoreName(storeName);
        DriverSharedPreference().setStoreUrl(baseUrl);
        Navigation().navigateToDriverLogin(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid Store Name"),
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
                  child: Center(
                    child: Image(
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width / 2,
                      height: 150.0,
                      image: const AssetImage(
                        "assets/images/store_image.png",
                      ),
                    ),
                  ),
                ),
                Text(
                  "Enter Your Store Id",
                  style: GoogleFonts.lato(
                    color: Colors.black,
                    fontSize: 18.0,
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
                      filled: _storeController.text.isEmpty ? true : false,
                      fillColor: const Color.fromRGBO(245, 245, 245, 1),
                      hintText: "Enter Your Store Id Here",
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
                    controller: _storeController,
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
                          onPressed: _storeController.text.isNotEmpty
                              ? () {
                                  setState(() {
                                    _loading = true;
                                  });
                                  checkStoreName();
                                }
                              : () {
                                  var snackbar = ScaffoldMessenger.of(context);
                                  snackbar.showSnackBar(SnackBar(
                                    content:
                                        const Text("Enter Store Name First"),
                                    action: SnackBarAction(
                                      label: "OK",
                                      onPressed: snackbar.hideCurrentSnackBar,
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
                                40.0,
                              ),
                            ),
                          ),
                          color: _storeController.text.isEmpty
                              ? const Color.fromRGBO(245, 245, 245, 1)
                              : Colors.orange,
                          child: const Text(
                            "Setup",
                          ),
                        ),
                      ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              Text(
                "Powered By ",
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.w400,
                  fontSize: 8,
                ),
              ),
              Text(
                "Turns",
                style: GoogleFonts.lato(
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
