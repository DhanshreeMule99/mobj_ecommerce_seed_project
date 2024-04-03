import 'package:http/http.dart' as http;
import 'package:mobj_project/utils/cmsConfigue.dart';

class LoginRepository {
  signIn(Map<String, dynamic> body) async {
    String exceptionString = "";
    try {
      String BASE_URL = AppConfigure.baseUrl + APIConstants.apiURL;

      if (await ConnectivityUtils.isNetworkConnected()) {
        final response = await http.post(Uri.parse(BASE_URL),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(body));
        var data = jsonDecode(response.body);
        if (response.statusCode == APIConstants.successCode) {
          return data;
        } else if (response.statusCode == APIConstants.badRequest) {
          exceptionString = "4";
          return exceptionString;
        } else if (response.statusCode == APIConstants.dataNotFoundCode) {
          return "2";
        } else {
          exceptionString = AppString.serverError;

          return exceptionString;
        }
      } else {
        return "3";
      }
    } catch (error) {
      exceptionString = AppString.serverError;
      return exceptionString;
    }
  }

  sendOTP(Map<String, dynamic> body) async {
    String exceptionString = "";

    try {
      String BASE_URL = AppConfigure.baseUrl + APIConstants.apiURL;

      if (await ConnectivityUtils.isNetworkConnected()) {
        final response = await http.post(Uri.parse(BASE_URL),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(body));

        var data = jsonDecode(response.body);
        if (response.statusCode == APIConstants.successCode) {
          return data;
        } else if (response.statusCode == APIConstants.badRequest) {
          exceptionString = "4";
          return exceptionString;
        } else if (response.statusCode == APIConstants.dataNotFoundCode) {
          return "2";
        } else {
          exceptionString = AppString.serverError;

          return exceptionString;
        }
      } else {
        return "3";
      }
    } catch (error) {
      exceptionString = AppString.serverError;
      return exceptionString;
    }
  }

  verifyOTP(Map<String, dynamic> body) async {
    String exceptionString = "";

    try {
      String BASE_URL = AppConfigure.baseUrl + APIConstants.apiURL;

      if (await ConnectivityUtils.isNetworkConnected()) {
        final response = await http.post(Uri.parse(BASE_URL),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(body));

        var data = jsonDecode(response.body);
        if (response.statusCode == APIConstants.successCode) {
          return data;
        } else if (response.statusCode == APIConstants.badRequest) {
          exceptionString = "4";
          return exceptionString;
        } else if (response.statusCode == APIConstants.dataNotFoundCode) {
          return "2";
        } else {
          exceptionString = AppString.serverError;

          return exceptionString;
        }
      } else {
        return "3";
      }
    } catch (error) {
      exceptionString = AppString.serverError;
      return exceptionString;
    }
  }

  forgotPassword(Map<String, dynamic> body) async {
    String exceptionString = "";
    try {
      String BASE_URL = AppConfigure.baseUrl + APIConstants.apiURL;

      if (await ConnectivityUtils.isNetworkConnected()) {
        final response = await http.patch(Uri.parse(BASE_URL),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(body));

        var data = jsonDecode(response.body);
        if (response.statusCode == APIConstants.successCode) {
          return data;
        } else if (response.statusCode == APIConstants.badRequest) {
          exceptionString = "4";
          return exceptionString;
        } else if (response.statusCode == APIConstants.dataNotFoundCode) {
          return "2";
        } else {
          exceptionString = AppString.serverError;

          return exceptionString;
        }
      } else {
        return "3";
      }
    } catch (error) {
      exceptionString = AppString.serverError;
      return exceptionString;
    }
  }
}
