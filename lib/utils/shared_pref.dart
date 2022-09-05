import 'package:shared_preferences/shared_preferences.dart';

class DriverSharedPreference {
  Future<String> getInitialRoute() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("main_url")) {
      return Future.value("web");
    } else if (prefs.containsKey("store_url")) {
      return Future.value("driver");
    } else {
      return Future.value("store");
    }
  }

  Future<void> setStoreName(String storeName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("store_name", storeName);
  }

  Future<void> setStoreUrl(String storeUrl) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("store_url", storeUrl);
  }

  Future<void> clearSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<String> getDriverId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("driver_id")!;
  }

  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
  }

  Future<String> getStoreUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("store_url")!;
  }

  Future<void> setMainUrl(
    String storeUrl,
    String driverId,
    String? token,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("main_url", "$storeUrl/driverHome/$driverId/$token");
  }


  Future<void> setDriverId(String driverId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("driver_id", driverId);
  }
}
