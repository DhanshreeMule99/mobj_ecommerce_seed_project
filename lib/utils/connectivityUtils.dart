import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityUtils {
  ///for checking Network
  static Future<bool> isNetworkConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return (true && (await isInternetConnected()));
    } else {
      return ((connectivityResult == ConnectivityResult.wifi) &&
          (await isInternetConnected()));
    }
  }

  ///For checking actual internet
  static Future<bool> isInternetConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 10));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException {
      return false;
    }
  }
}
