import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';

import '../../../../utils/api.dart';

class UserRepository {
  List<UserModel> empty = [];

  Future<List<UserModel>> getUsers() async {
    try {
      String baseUrl = AppConfigure.baseUrl + APIConstants.apiURL;

      final response = await ApiManager.get(baseUrl);
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
    API api = API();
    debugPrint('calling profile api');
    if (AppConfigure.bigCommerce) {
      debugPrint('calling bigcommerce profile api');
      try {
        String baseUrl = AppConfigure.baseUrl;
        final uid = await SharedPreferenceManager().getUserId();
        final response = await ApiManager.get("$baseUrl/customers?id:in=$uid");
        if (response.statusCode == APIConstants.successCode) {
          // ref.refresh(profileDataProvider);
          final result = jsonDecode(response.body)['data'][0];
          await SharedPreferenceManager()
              .setname(result['first_name'].toString());
          await SharedPreferenceManager().setemail(result['email'].toString());
          debugPrint('result is this $result');
          return CustomerModel.fromJson(result);
        } else {
          throw Exception(response.reasonPhrase);
        }
      } catch (error) {
        debugPrint('profile data error is this $error');
        rethrow;
      }
    }
    else 
    if (AppConfigure.wooCommerce){
 debugPrint('calling bigcommerce profile api');
      try {
       String cunsumerKey = AppConfigure.consumerkey;
       String cumsumerSecret = AppConfigure.consumersecret;
        final uid = await SharedPreferenceManager().getUserId();
        log(" woo commerce UID : $uid");
        final response = await api.sendRequest.get("/wp-json/wc/v3/customers/$uid?consumer key=$cunsumerKey&consumer secret=$cumsumerSecret",
        
        );
        if (response.statusCode == APIConstants.successCode) {
          // ref.refresh(profileDataProvider);
          final result = response.data;
          await SharedPreferenceManager()
              .setname(result['first_name'].toString());
          await SharedPreferenceManager().setemail(result['email'].toString());
          debugPrint('result is this $result');
          return CustomerModel.fromJson(result);
        } else {
          throw Exception(response.data);
        }
      } catch (error) {
        debugPrint('profile data error is this $error');
        rethrow;
      }


    }
    
     else {
      try {
        String baseUrl = AppConfigure.baseUrl +
            APIConstants.apiForAdminURL +
            APIConstants.apiURL +
            APIConstants.customer;
        final uid = await SharedPreferenceManager().getUserId();
        final accessToken = await SharedPreferenceManager().getToken();
        log("access token is this $accessToken");
        String query = '''
query {
  customer(customerAccessToken: "$accessToken") {
    id
    firstName
    lastName
    email
    phone
    createdAt
    updatedAt
    numberOfOrders
    
    defaultAddress {
      id
      address1
      city
      province
      country
      zip
    }
  }
}
''';

        Response response = await api.sendRequest.post(
            'https://pyvaidyass.myshopify.com/api/2023-10/graphql.json',
            data: {"query": query});

        log('shopify customer details reuslt is this ${response.data['data']['customer']}');
        if (response.statusCode == APIConstants.successCode) {
          final result = response.data['data']['customer'];
          return CustomerModel.fromJson(result);
        } else {
          throw Exception("something went wrong");
        }
      } catch (error, stackTrace) {
        debugPrint('profile error is this $error $stackTrace');
        rethrow;
      }
    }
  }

  Future<ProfileModel> getUserInfo(String uid) async {
    try {
      String baseUrl = AppConfigure.baseUrl + APIConstants.apiURL;

      final response = await ApiManager.get("$baseUrl$uid/$uid");
      if (response.statusCode == APIConstants.successCode) {
        final userData = json.decode(response.body)['data'];

        return ProfileModel.fromJson(userData);
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (error) {
      rethrow;
    }
  }

  editProfile(Map<String, dynamic> body) async {
    String exceptionString = "";
    final uid = await SharedPreferenceManager().getUserId();
    debugPrint('getting 2');
    API api = API();
    if (AppConfigure.bigCommerce) {

// edit customer details for bigCommerce 

      String baseUrl = AppConfigure.baseUrl +
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
              "X-auth-Token": AppConfigure.bigCommerceAccessToken
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
    } else if (AppConfigure.wooCommerce ){
  
        // edit customer for WooCommerce
    debugPrint('Calling edit woo commerce api');
      var body1 = jsonEncode({"customer": body});
      try {
         final uid = await SharedPreferenceManager().getUserId();
               String cunsumerKey = AppConfigure.consumerkey;
       String cumsumerSecret = AppConfigure.consumersecret;
        if (await ConnectivityUtils.isNetworkConnected()) {
          Response response = await api.sendRequest.put(
            '/wp-json/wc/v3/customers/$uid?consumer key=$cunsumerKey&consumer secret=$cumsumerSecret',
            data: body,
            options: Options(headers: {
              'Content-Type': 'application/json',
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


    }
    
    else {
      // edit customer details  by shpify 
      String baseUrl = AppConfigure.baseUrl +
          APIConstants.apiForAdminURL +
          APIConstants.apiURL +
          APIConstants.customer;

      var body1 = jsonEncode({"customer": body});
      try {
        if (await ConnectivityUtils.isNetworkConnected()) {
          String query = '''
            mutation customerUpdate(\$customerAccessToken: String!, \$customer: CustomerUpdateInput!) {
  customerUpdate(customerAccessToken: \$customerAccessToken, customer: \$customer) {
    customer {
      id
      firstName
      lastName
      phone
      # Add other fields you want to update
    }
    userErrors {
      field
      message
    }
  }
}

          ''';

          Map<String, dynamic> variables = body;
          Response response = await api.sendRequest.post(
            "https://pyvaidyass.myshopify.com/api/2023-10/graphql.json",
            data: {
              'query': query,
              'variables': variables,
            },
          );
          var data = response.data;
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
