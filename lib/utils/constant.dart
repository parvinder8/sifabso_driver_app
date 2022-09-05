import '../screens/driver_login.dart';
import '../screens/otp.dart';
import '../screens/store_login.dart';
import '../screens/web_screen.dart';

class Constants {
  var driverRoutes = {
    'store': (context) => const StoreLoginPage(),
    'driver': (context) => const DriverLoginPage(),
    'otp': (context) => const OtpPage(),
    'web': (context) => const DriverWebView()
  };
}
