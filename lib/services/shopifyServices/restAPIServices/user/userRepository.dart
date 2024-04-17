import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';

import '../../../../models/shopifyModel/product/draftOrderModel.dart';
import '../../../../utils/api.dart';

class UserRepository {
  List<UserModel> empty = [];

  Future<List<UserModel>> getUsers() async {
    try {
      String BASE_URL = AppConfigure.baseUrl + APIConstants.apiURL;

      final response = await ApiManager.get(BASE_URL);
      if (response.statusCode == APIConstants.successCode) {
        final List result = jsonDecode(response.body)['data'];
        return result.map((e) => UserModel.fromJson(e)).toList();
      } else if (response.statusCode == APIConstants.dataNotFoundCode) {
        return empty;
      } else if (response.statusCode == APIConstants.unAuthorizedCode) {
        throw AppString.unAuthorized;
      } else {
        return empty;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<CustomerModel> getProfile() async {
    log('calling profile api');
    if (AppConfigure.bigCommerce) {
      log('calling bigcommerce profile api');
      try {
        String BASE_URL = AppConfigure.baseUrl;
        final uid = await SharedPreferenceManager().getUserId();
        final response = await ApiManager.get("$BASE_URL/customers?id:in=$uid");
        if (response.statusCode == APIConstants.successCode) {
          
    // ref.refresh(profileDataProvider);
          final result = jsonDecode(response.body)['data'][0];
await SharedPreferenceManager().setname(result['first_name'].toString());
await SharedPreferenceManager().setemail(result['email'].toString());
          log('result is this $result');
          return CustomerModel.fromJson(result);
        } else {
          throw Exception(response.reasonPhrase);
        }
      } catch (error) {
        log('profile data error is this $error');
        throw error;
      }
    } else {
      try {
        String BASE_URL = AppConfigure.baseUrl +
            APIConstants.apiForAdminURL +
            APIConstants.apiURL +
            APIConstants.customer;
        final uid = await SharedPreferenceManager().getUserId();
        final response = await ApiManager.get("$BASE_URL$uid.json");
        if (response.statusCode == APIConstants.successCode) {
          final result = jsonDecode(response.body)['customer'];
          return CustomerModel.fromJson(result);
        } else {
          throw Exception(response.reasonPhrase);
        }
      } catch (error) {
        throw error;
      }
    }
  }

  Future<ProfileModel> getUserInfo(String uid) async {
    try {
      String BASE_URL = AppConfigure.baseUrl + APIConstants.apiURL;

      final response = await ApiManager.get("$BASE_URL${uid}/$uid");
      if (response.statusCode == APIConstants.successCode) {
        final userData = json.decode(response.body)['data'];

        return ProfileModel.fromJson(userData);
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (error) {
      throw error;
    }
  }

  editProfile(Map<String, dynamic> body) async {
    String exceptionString = "";
    final uid = await SharedPreferenceManager().getUserId();
    log('getting 2');
    API api = API();
    if (AppConfigure.bigCommerce) {
      String BASE_URL = AppConfigure.baseUrl +
          APIConstants.apiForAdminURL +
          APIConstants.apiURL +
          APIConstants.customer;

      var body1 = jsonEncode({"customer": body});
      try {
        if (await ConnectivityUtils.isNetworkConnected()) {
          Response response = await api.sendRequest.put(
            '/customers',
            data: [body],
            options: Options(headers: {
              'Content-Type': 'application/json',
              "X-auth-Token": "${AppConfigure.bigCommerceAccessToken}"
            }),
          );

          if (response.statusCode == APIConstants.successCode) {
            return response;
          } else if (response.statusCode == APIConstants.unAuthorizedCode) {
            exceptionString = AppString.unAuthorized;
            return exceptionString;
          } else {
            exceptionString = AppString.serverError;
            return exceptionString;
          }
        } else {
          var exceptionString = AppString.checkInternet;
          return exceptionString;
        }
      } catch (error) {
        exceptionString = AppString.serverError;
        return exceptionString;
      }
    } else {
      String BASE_URL = AppConfigure.baseUrl +
          APIConstants.apiForAdminURL +
          APIConstants.apiURL +
          APIConstants.customer;

      var body1 = jsonEncode({"customer": body});
      try {
        if (await ConnectivityUtils.isNetworkConnected()) {
          final response = await ApiManager.put("$BASE_URL$uid.json", body1);
          var data = jsonDecode(response.body);
          if (response.statusCode == APIConstants.successCode) {
            return data;
          } else if (response.statusCode == APIConstants.unAuthorizedCode) {
            exceptionString = AppString.unAuthorized;
            return exceptionString;
          } else {
            exceptionString = AppString.serverError;
            return exceptionString;
          }
        } else {
          var exceptionString = AppString.checkInternet;
          return exceptionString;
        }
      } catch (error) {
        exceptionString = AppString.serverError;
        return exceptionString;
      }
    }
  }
}

final usersProvider = Provider<UserRepository>((ref) => UserRepository());
