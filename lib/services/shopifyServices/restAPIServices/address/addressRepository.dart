// addressRepository
import 'dart:developer';

import 'package:mobj_project/utils/cmsConfigue.dart';

class AddressRepository {
  List<DefaultAddressModel> empty = [];
  String BASE_URL = AppConfigure.baseUrl +
      APIConstants.apiForAdminURL +
      APIConstants.apiURL +
      APIConstants.customer;

  Future<List<DefaultAddressModel>> getAddress() async {
    final uid = await SharedPreferenceManager().getUserId();
    try {
      final response =
          await ApiManager.get("$BASE_URL$uid/${APIConstants.address}.json");
      if (response.statusCode == APIConstants.successCode) {
        log("body is this ${response.body} $uid");
        final List result = jsonDecode(response.body)['addresses'];
        if (result.isEmpty) {
          throw (AppString.noDataError);
        } else {
          return result.map((e) => DefaultAddressModel.fromJson(e)).toList();
        }
      } else if (response.statusCode == APIConstants.dataNotFoundCode) {
        throw (AppString.noDataError);
      } else if (response.statusCode == APIConstants.unAuthorizedCode) {
        throw AppString.unAuthorized;
      } else {
        return empty;
      }
    } catch (error) {
      rethrow;
    }
  }

  deleteAddress(String addId) async {
    String exceptionString = "";
    final uid = await SharedPreferenceManager().getUserId();
    String BASE_URL = AppConfigure.baseUrl +
        APIConstants.apiForAdminURL +
        APIConstants.apiURL +
        APIConstants.customer;

    try {
      if (await ConnectivityUtils.isNetworkConnected()) {
        final response = await ApiManager.delete(
            "$BASE_URL$uid/${APIConstants.address}/$addId.json");
        var data = jsonDecode(response.body);
        if (response.statusCode == APIConstants.successCode) {
          return AppString.success;
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

  editAddress(Map<String, dynamic> body, String addId) async {
    String exceptionString = "";
    final uid = await SharedPreferenceManager().getUserId();
    String BASE_URL = AppConfigure.baseUrl +
        APIConstants.apiForAdminURL +
        APIConstants.apiURL +
        APIConstants.customer;

    var body1 = jsonEncode({"address": body});
    try {
      if (await ConnectivityUtils.isNetworkConnected()) {
        final response;
        if (addId == "") {
          log("calling null addressid api");
          response = await ApiManager.post(
              "$BASE_URL$uid/${APIConstants.address}.json", body1);
        } else {
          log("calling not null addressid api");
          response = await ApiManager.put(
              "$BASE_URL$uid/${APIConstants.address}/$addId.json", body1);
        }
        print("body is this ${response.body}");
        var data = jsonDecode(response.body);
        if (response.statusCode == APIConstants.successCode ||
            response.statusCode == APIConstants.successCreateCode) {
          return data;
        } else if (response.statusCode == APIConstants.unAuthorizedCode) {
          exceptionString = AppString.unAuthorized;
          return exceptionString;
        } else if (response.statusCode == APIConstants.alreadyExistCode) {
          exceptionString = AppString.alreadyExist;
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

  setDefaultAddress(String addId) async {
    String exceptionString = "";
    final uid = await SharedPreferenceManager().getUserId();
    String BASE_URL = AppConfigure.baseUrl +
        APIConstants.apiForAdminURL +
        APIConstants.apiURL +
        APIConstants.customer;

    try {
      if (await ConnectivityUtils.isNetworkConnected()) {
        final response = await ApiManager.put(
            "$BASE_URL$uid/${APIConstants.address}/$addId/${APIConstants.defaultAddress}.json",
            {});
        var data = jsonDecode(response.body);
        if (response.statusCode == APIConstants.successCode) {
          return AppString.success;
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

final addressProvider =
    Provider<AddressRepository>((ref) => AddressRepository());
