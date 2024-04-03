// resetPasswordRepository.dart
import 'package:mobj_project/utils/cmsConfigue.dart';

class ResetPasswordRepository {
  resetPassword(Map<String, dynamic> body) async {
    String exceptionString = "";
    var body1 = jsonEncode(body);

    try {
      if (await ConnectivityUtils.isNetworkConnected()) {
        final response = await ApiManager.patch(AppConfigure.baseUrl, body1);

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
