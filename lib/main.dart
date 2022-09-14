import 'package:flutter/material.dart';
import 'package:turns_fleet/utils/constant.dart';
import 'package:turns_fleet/utils/shared_pref.dart';

var _initialRoute = "store";



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _initialRoute = await DriverSharedPreference().getInitialRoute();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Turns Fleet',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      initialRoute: _initialRoute,
      routes: Constants().driverRoutes,
    );
  }
}
