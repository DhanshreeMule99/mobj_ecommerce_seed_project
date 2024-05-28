// import 'package:mobj_project/utils/cmsConfigue.dart';

// class AppInfo {
//   final String appName;
//   final String primaryColor;
//   final String secondaryColor;
//   final String logoImagePath;
//   final String baseUrl;
//   final String aboutApp;
//   final String tawkURL;
//   final String apiFramework;

//   AppInfo(
//     this.appName,
//     this.primaryColor,
//     this.secondaryColor,
//     this.logoImagePath,
//     this.baseUrl,
//     this.aboutApp,
//     this.tawkURL,
//     this.apiFramework,
//   );

//   Color get primaryColorValue =>
//       Color(int.parse(primaryColor.replaceAll("#", "0xFF")));

//   Color get secondaryColorValue =>
//       Color(int.parse(secondaryColor.replaceAll("#", "0xFF")));

// }

// final appInfoProvider = FutureProvider<AppInfo>((ref) {
//   return AppInfo(
//     AppConfigure.appName,
//     AppConfigure.primaryColor,
//     AppConfigure.secondaryColor,
//     AppConfigure.logoImagePath,
//     AppConfigure.baseUrl,
//     AppConfigure.aboutApp,
//     AppConfigure.tawkURL,
//     AppConfigure.apiFramework,
//   );
// });



import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mobj_project/module/onboarding/onboardScreen.dart';
import 'dart:convert';

import 'package:mobj_project/utils/appConfiguer.dart';

class AppInfo {
  final String appName;
  final String primaryColor;
  final String secondaryColor;
  final String logoImagePath;
  final String baseUrl;
  final String aboutApp;
  final String tawkURL;
  final String apiFramework;

  AppInfo({
    required this.appName,
    required this.primaryColor,
    required this.secondaryColor,
    required this.logoImagePath,
    required this.baseUrl,
    required this.aboutApp,
    required this.tawkURL,
    required this.apiFramework,
  });

  Color get primaryColorValue =>
      Color(int.parse(primaryColor.replaceAll("#", "0xFF")));
  Color get secondaryColorValue =>
      Color(int.parse(secondaryColor.replaceAll("#", "0xFF")));
}

final appInfoProvider = FutureProvider<AppInfo>((ref) async {
  const apiUrl = 'https://c0a6-2409-40c2-1196-1baf-c01d-6b7-511c-6c.ngrok-free.app/api/about-uses';
  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    final aboutApp = jsonData['data'][0]['attributes']['about'];

    return AppInfo(
      appName: AppConfigure.appName,
      primaryColor: AppConfigure.primaryColor,
      secondaryColor: AppConfigure.secondaryColor,
      logoImagePath: AppConfigure.logoImagePath,
      baseUrl: AppConfigure.baseUrl,
      aboutApp: aboutApp,
      tawkURL: AppConfigure.tawkURL,
      apiFramework: AppConfigure.apiFramework,
    );
  } else {
    throw Exception('Failed to load logo image');
  }
});


