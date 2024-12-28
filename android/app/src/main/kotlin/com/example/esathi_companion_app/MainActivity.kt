package com.example.esathi_companion_app

import android.content.Context
import android.net.ConnectivityManager
import android.net.NetworkInfo
import android.net.wifi.WifiInfo
import android.net.wifi.WifiManager
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.esathi_companion_app/wifi" // Define a unique channel name

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Set up the platform channel to communicate with Flutter code
        MethodChannel(flutterEngine!!.dartExecutor, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getWiFiStatus") {
                val wifiStatus = getWiFiStatus()
                result.success(wifiStatus) // Send the status to Flutter
            } else {
                result.notImplemented()
            }
        }
    }

    // Function to get Wi-Fi connection status
    private fun getWiFiStatus(): String {
        val connectivityManager = applicationContext.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        val networkInfo: NetworkInfo? = connectivityManager.activeNetworkInfo

        return if (networkInfo != null && networkInfo.isConnected && networkInfo.type == ConnectivityManager.TYPE_WIFI) {
            // If Wi-Fi is connected, get the SSID
            val wifiManager = applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
            val wifiInfo: WifiInfo = wifiManager.connectionInfo
            if (wifiInfo.ssid != null && wifiInfo.ssid != "<unknown ssid>") {
                "Connected to ${wifiInfo.ssid}"
            } else {
                "Wi-Fi connected, but no SSID found"
            }
        } else {
            "Not connected to Wi-Fi"
        }
    }
}
