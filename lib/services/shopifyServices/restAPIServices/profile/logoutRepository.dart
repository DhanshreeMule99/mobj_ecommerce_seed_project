// logoutRepository
import 'package:dio/dio.dart';
import 'package:mobj_project/utils/api.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';

class logoutRepository {


  Future<bool> accountDeactivate() async {

API api= API();
if(AppConfigure.bigCommerce){
if (await ConnectivityUtils.isNetworkConnected()) {
 
      final uid = await SharedPreferenceManager().getUserId();
      final response = await api.sendRequest.delete(
          "/customers?id:in=$uid",
          options: Options(headers: {
              "X-auth-Token": "${AppConfigure.bigCommerceAccessToken}",
            
            }) );
      // var data = response.data;
      if (response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }

}

else

   { if (await ConnectivityUtils.isNetworkConnected()) {
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
}
