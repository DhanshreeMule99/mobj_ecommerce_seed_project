import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:mobj_project/utils/cmsConfigue.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiManager {
  static Future<http.Response> get(String apiName) async {
    final Uri url = Uri.parse(apiName);
    final String? token = (await getToken());
    final String storeFrontToken = (await getStoreFrontToken() ?? "");

    final headers = AppConfigure.bigCommerce == true
        ? {"X-auth-Token": "${AppConfigure.bigCommerceAccessToken}"}
        : {
            'X-Shopify-Access-Token': '$token',
            "X-Shopify-Storefront-Access-Token": storeFrontToken,
            'Content-Type': 'application/json',
            'SECRET-KEY': AppConfigure.feraSecretKey
          };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == APIConstants.unAuthorizedCode ||
        response.statusCode == APIConstants.forbiddenCode) {
      await logout();
    }

    return response;
  }

  static Future<http.Response> post(String apiName, dynamic body) async {
    final Uri url = Uri.parse(apiName);
    final String? token = (await getToken());
    final String storeFrontToken = (await getStoreFrontToken() ?? "");
    final headers = {
      //'Authorization': 'Bearer $token',
      "X-Shopify-Access-Token": token!,
      "X-Shopify-Storefront-Access-Token": storeFrontToken,
      'Content-Type': 'application/json',
      "SECRET-KEY": AppConfigure.feraSecretKey
    };
    print("headers*******$headers");
    final response = await http.post(url,
        headers: headers, body: body.toString() != "{}" ? body : null);

    log(" add to cart ${response.statusCode}");
    if (response.statusCode == APIConstants.unAuthorizedCode ||
        response.statusCode == APIConstants.forbiddenCode) {
      await logout();
    }

    return response;
  }

  static Future<http.Response> delete(String apiName) async {
    final Uri url = Uri.parse(apiName);
    final String? token = (await getToken());
    final String storeFrontToken = (await getStoreFrontToken() ?? "");
    final headers = {
// 'Authorization': 'Bearer $token',
      'X-Shopify-Access-Token': '$token',
      "X-Shopify-Storefront-Access-Token": storeFrontToken,
      'Content-Type': 'application/json',
    };

    final response = await http.delete(url, headers: headers);
    if (response.statusCode == APIConstants.unAuthorizedCode ||
        response.statusCode == APIConstants.forbiddenCode) {
      await logout();
    }

    return response;
  }

  static Future<http.Response> put(String apiName, dynamic body) async {
    final Uri url = Uri.parse(apiName);
    final String? token = (await getToken());
    final String storeFrontToken = (await getStoreFrontToken() ?? "");
    final headers = {
// 'Authorization': 'Bearer $token',
      'X-Shopify-Access-Token': '$token',
      "X-Shopify-Storefront-Access-Token": storeFrontToken,
      'Content-Type': 'application/json',
    };

    final response = await http.put(url,
        headers: headers, body: body.toString() != "{}" ? body : null);

    if (response.statusCode == APIConstants.unAuthorizedCode ||
        response.statusCode == APIConstants.forbiddenCode) {
      await logout();
    }

    return response;
  }

  static Future<http.Response> patch(String apiName, dynamic body) async {
    final Uri url = Uri.parse(apiName);
    final String? token = (await getToken());
    final String storeFrontToken = (await getStoreFrontToken() ?? "");
    final headers = {
// 'Authorization': 'Bearer $token',
      'X-Shopify-Access-Token': '$token',
      "X-Shopify-Storefront-Access-Token": storeFrontToken,
      'Content-Type': 'application/json',
    };
    final response = await http.patch(url,
        headers: headers, body: body.toString() != "{}" ? body : null);

    if (response.statusCode == APIConstants.unAuthorizedCode ||
        response.statusCode == APIConstants.forbiddenCode) {
      await logout();
    }

    return response;
  }

  static Future<String?> getToken() async {
    const String? token = AppConfigure.accessToken;
    return token;
  }

  static Future<String?> getStoreFrontToken() async {
    const String token = AppConfigure.storeFrontToken;
    return token;
  }

  static Future<void> logout() async {
    if (getToken().toString() != "") {
      // GoogleSignIn _googleSignIn = GoogleSignIn();
      // await _googleSignIn.disconnect();
      // await FirebaseAuth.instance.signOut();
      //TODO list logout if unauthrized user
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.remove('token');
      // prefs.remove('userid');
      // prefs.remove('profile');
      // prefs.remove("googleToken");
      // Fluttertoast.showToast(
      //     msg: "Unauthorized user",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: app_colors.black_color,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
      // navigatorKey.currentState!.pushNamedAndRemoveUntil(
      //     RouteConstants.login,(route) => false,);
      // navigatorKey.currentState!.pushAndRemoveUntil(
      //   MaterialPageRoute(
      //       builder: (_) => LoginScreen()),
      //   (route) => false,
      // );
    }
  }
}
