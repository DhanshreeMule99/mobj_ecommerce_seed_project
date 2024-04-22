// Device_repository
import 'package:device_info_plus/device_info_plus.dart';

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';

class DeviceRepository {
  deviceInfo(String userId) async {
    Map<String, dynamic>? body1;
    String exceptionString;
    // final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    // final token = await _fcm.getToken();
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    Map<String, dynamic>? deviceInfo;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // var uniqueId = await SharedPreferenceManager().getDeviceId();
// try {
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      deviceInfo = <String, dynamic>{
        'userId': userId,
        'deviceId': build.id,
        'osVersion': build.version.sdkInt.toString(),
        'osName': 'Android',
        'devicePlatform': 'Android',
        'appVersion': packageInfo.version,
        'deviceTimezone': DateTime.now().timeZoneName,
        'deviceCurrentTimestamp':
            DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
        // 'token': token.toString(),
        'token': "",
        'modelName': build.model
      };
    } else if (Platform.isIOS) {
      var build = await deviceInfoPlugin.iosInfo;
      deviceInfo = <String, dynamic>{
        'userId': userId,
        'deviceId': build..identifierForVendor,
        'osVersion': build.systemVersion,
        'osName': 'iOS',
        'devicePlatform': 'iOS',
        'appVersion': packageInfo.version,
        'deviceTimezone': DateTime.now().timeZoneName,
        'deviceCurrentTimestamp':
            DateFormat("dd/MM/y HH:mm:ss").format(DateTime.now()),
        // 'token': token.toString(),
        'token': '',
        'modelName': build.utsname.machine
      };
    }
    var body = jsonEncode(deviceInfo);

    try {
      if (await ConnectivityUtils.isNetworkConnected()) {
        final response = await http.post(Uri.parse(AppConfigure.baseUrl),
            headers: {"Content-Type": "application/json"}, body: body);
        var data = jsonDecode(response.body);
        if (response.statusCode == APIConstants.successCode) {
          return data;
        } else if (response.statusCode == APIConstants.unAuthorizedCode) {
          exceptionString = AppString.serverError;
          return exceptionString;
        } else {
          exceptionString = AppString.serverError;

          return exceptionString;
        }
      } else {
        var exceptionString = AppString.checkInternet;

        return exceptionString;
      }
    } catch (error) {
      exceptionString = AppString.serverError;
      return exceptionString;
    }
  }
}
