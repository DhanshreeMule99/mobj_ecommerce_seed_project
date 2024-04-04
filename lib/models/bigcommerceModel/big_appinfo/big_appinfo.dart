import 'package:mobj_project/utils/cmsConfigue.dart';

class BigAppInfo {
  final String appName;
  final String primaryColor;
  final String secondaryColor;
  final String logoImagePath;
  final String baseUrl;
  final String aboutApp;
  final String tawkURL;
  final String apiFramework;

  BigAppInfo(
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

final appInfoProvider = FutureProvider<BigAppInfo>((ref) {
  return BigAppInfo(
    AppConfigure.appName,
    AppConfigure.primaryColor,
    AppConfigure.secondaryColor,
    AppConfigure.logoImagePath,
    AppConfigure.baseUrl,
    AppConfigure.aboutApp,
    AppConfigure.tawkURL,
    AppConfigure.apiFramework,
  );
});
