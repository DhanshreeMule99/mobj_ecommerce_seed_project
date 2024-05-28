import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mobj_project/utils/cmsConfigue.dart';
import '../../utils/api.dart';

class AppInfo {
  final String appName;
  final String primaryColor;
  final String secondaryColor;
  final String logoImagePath;
  final String baseUrl;
  final String aboutApp;
  final String tawkURL;
  final String apiFramework;

  AppInfo(
    this.appName,
    this.primaryColor,
    this.secondaryColor,
    this.logoImagePath,
    this.baseUrl,
    this.aboutApp,
    this.tawkURL,
    this.apiFramework,
  );

  Color get primaryColorValue =>
      Color(int.parse(primaryColor.replaceAll("#", "0xFF")));

  Color get secondaryColorValue =>
      Color(int.parse(secondaryColor.replaceAll("#", "0xFF")));
}

Future<AppInfo> fetchAppInfo() async {
  API api = API();
  final response = await api.sendRequest.get(
      "https://c0a6-2409-40c2-1196-1baf-c01d-6b7-511c-6c.ngrok-free.app/api/logos");

  if (response.statusCode == 200) {
    log("Response received");
    final responseBody = response.data;
    final logoImagePath = responseBody['data'][0]['attributes']['image_url'];
    log('Image path: $logoImagePath');

    return AppInfo(
      AppConfigure.appName,
      AppConfigure.primaryColor,
      AppConfigure.secondaryColor,
      logoImagePath,
      AppConfigure.baseUrl,
      AppConfigure.aboutApp,
      AppConfigure.tawkURL,
      AppConfigure.apiFramework,
    );
  } else {
    throw Exception('Failed to load app info');
  }
}

final appInfoProvider = FutureProvider<AppInfo>((ref) async {
  return await fetchAppInfo();
});
