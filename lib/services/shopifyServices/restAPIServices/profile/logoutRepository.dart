// logoutRepository
import 'package:mobj_project/utils/cmsConfigue.dart';

class logoutRepository {


  Future<bool> accountDeactivate() async {

    if (await ConnectivityUtils.isNetworkConnected()) {
      String BASE_URL = AppConfigure.baseUrl +
          APIConstants.apiForAdminURL +
          APIConstants.apiURL +
          APIConstants.customer;
      final uid = await SharedPreferenceManager().getUserId();
      final response = await ApiManager.delete(
          "$BASE_URL$uid.json");
      var data = jsonDecode(response.body);
      if (response.statusCode == APIConstants.successCode) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
