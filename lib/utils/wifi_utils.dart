import 'package:network_info_plus/network_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class WifiUtils {
  static Future<String> getWifiInfo() async {
    final NetworkInfo networkInfo = NetworkInfo();
    String wifiName = "Unknown";

    try {
      wifiName = (await networkInfo.getWifiName())?.replaceAll('"', '').trim() ?? "Unknown";
    } catch (e) {
      wifiName = "Error: $e";
    }

    return wifiName;
  }

  static Future<bool> isNetworkAvailable() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  static Stream<ConnectivityResult> getConnectivityStream() {
    return Connectivity().onConnectivityChanged;
  }
}
