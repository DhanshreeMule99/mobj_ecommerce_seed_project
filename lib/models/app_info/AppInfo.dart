

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
 

    return AppInfo(
      appName: AppConfigure.appName,
      primaryColor: AppConfigure.primaryColor,
      secondaryColor: AppConfigure.secondaryColor,
      logoImagePath: AppConfigure.logoImagePath,
      baseUrl: AppConfigure.baseUrl,
      aboutApp:AppConfigure.aboutApp,
      tawkURL: AppConfigure.tawkURL,
      apiFramework: AppConfigure.apiFramework,
    );
  
});


