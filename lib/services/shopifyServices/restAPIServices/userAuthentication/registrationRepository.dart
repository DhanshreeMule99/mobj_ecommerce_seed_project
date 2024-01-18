// registrationRepository

import 'package:http/http.dart' as http;
import 'package:mobj_project/utils/cmsConfigue.dart';

class RegistrationRepository {
  signIn(Map<String, dynamic> body) async {
    String exceptionString = "";
    try {
      if (await ConnectivityUtils.isNetworkConnected()) {
        final response = await http.post(
            Uri.parse(AppConfigure.baseUrl + APIConstants.signIn),
            headers: {
              "Content-Type": "application/json",
              "X-Shopify-Access-Token": AppConfigure.accessToken
            },
            body: jsonEncode({"customer": body}));
        var data = jsonDecode(response.body);
        if (response.statusCode == APIConstants.successCode ||
            response.statusCode == APIConstants.successCreateCode) {
          return data;
        } else if (response.statusCode == APIConstants.badRequest) {
          exceptionString = "4";
          return exceptionString;
        } else if (response.statusCode == APIConstants.conflictCode ||
            response.statusCode == APIConstants.alreadyExistCode) {
          var data = jsonDecode(response.body);
          if (data["errors"] != null) {
            if (data["errors"]["email"] != null) {
              if (data["errors"]["email"].toString() ==
                  "[is invalid]") {
                exceptionString = AppString.emailValidationMsg ;
              } else {
                exceptionString = AppString.userExists;
              }
            } else if (data["errors"]["phone"] != null) {
              if (data["errors"]["phone"].toString() ==
                  "[Enter a valid phone number]") {
                exceptionString = AppString.phoneInValidationMsg;
              } else {
                exceptionString = AppString.userExists;
              }
            } else {
              exceptionString = AppString.serverError;
            }
          }
          return exceptionString;
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
