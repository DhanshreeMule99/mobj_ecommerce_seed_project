// addressRepository



import 'package:dio/dio.dart';
import 'package:http/src/response.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';

import '../../../../utils/api.dart';

class AddressRepository {
  List<DefaultAddressModel> empty = [];
  String BASE_URL = AppConfigure.baseUrl +
      APIConstants.apiForAdminURL +
      APIConstants.apiURL +
      APIConstants.customer;

  Future<List<DefaultAddressModel>> getAddress() async {
    final uid = await SharedPreferenceManager().getUserId();

    if (AppConfigure.bigCommerce) {
      try {
        final response = await ApiManager.get(
            "${AppConfigure.bigcommerceUrl}/customers/addresses?customer_id:in=$uid");
        if (response.statusCode == APIConstants.successCode) {
          debugPrint("body is this ${response.body} $uid");
          final List result = jsonDecode(response.body)['data'];
          debugPrint("body is this $result $uid");
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
    else
     if ( AppConfigure.wooCommerce){
 API api = API();
           
       try {
         debugPrint("calling get address list api0");
           String cunsumerKey = AppConfigure.consumerkey;
       String cumsumerSecret = AppConfigure.consumersecret;
        final response = await api.sendRequest.get(
            "/wp-json/wc/v3/customers/$uid?consumer key=$cunsumerKey&consumer secret=$cumsumerSecret");
        if (response.statusCode == APIConstants.successCode) {
          debugPrint("body is this ${response.data} $uid");
           
            // final result = response.data;
       //   debugPrint("body is this $result $uid");
          if (response.data['billing']['address_1']=="") {
            throw (AppString.noDataError);
            
          } else {
            
            return [DefaultAddressModel(id: response.data['id'], customerId: response.data['id'], firstName: response.data['billing']['first_name'], lastName: response.data['billing']['last_name'], address1: response.data['billing']['address_1'], city: response.data['billing']['city'], province: response.data['billing']['address_2'], country: response.data['billing']['country'], zip: response.data['billing']['postcode'], phone: response.data['billing']['phone'], name: response.data['billing']['first_name'], provinceCode: response.data['billing']['first_name'], countryCode: response.data['billing']['first_name'], countryName: response.data['billing']['first_name'], defaultAddress: false)];

          }
        } else if (response.statusCode == APIConstants.dataNotFoundCode) {
          throw (AppString.noDataError);
        } else if (response.statusCode == APIConstants.unAuthorizedCode) {
          throw AppString.unAuthorized;
        } else {
          return empty;
        }
      } catch (error, stackTrace) {
        print("error for address is this $error $stackTrace");
        rethrow;
      }
    }
    
    else {
      try {
        final response =
            await ApiManager.get("$BASE_URL$uid/${APIConstants.address}.json");
        if (response.statusCode == APIConstants.successCode) {
          debugPrint("body is this ${response.body} $uid");
          final List result = jsonDecode(response.body)['addresses'];
          if (result.isEmpty) {
            throw (AppString.noDataError);
          } else {
            return add.map((e) => DefaultAddressModel.fromJson(e)).toList();
          }
        } else if (response.statusCode == APIConstants.dataNotFoundCode) {
          throw (AppString.noDataError);
        } else if (response.statusCode == APIConstants.unAuthorizedCode) {
          throw AppString.unAuthorized;
        } else {
          return empty;
        }
      }  catch (error, stackTrace) {
        print('object $error $stackTrace');
        
        rethrow;
      }
    }
  }

  deleteAddress(String addId) async {
    String exceptionString = "";
    final uid = await SharedPreferenceManager().getUserId();
    String baseUrl = AppConfigure.baseUrl +
        APIConstants.apiForAdminURL +
        APIConstants.apiURL +
        APIConstants.customer;

    API api = API();
    if (AppConfigure.bigCommerce) {
      try {
        if (await ConnectivityUtils.isNetworkConnected()) {
          final response = await api.sendRequest.delete(
            "/customers/addresses?id:in=$addId",
            options: Options(headers: {
              'Content-Type': 'application/json',
              "X-auth-Token": AppConfigure.bigCommerceAccessToken
            }),
          );
          // var data = jsonDecode(response.body);
          if (response.statusCode == 204) {
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
    else if (AppConfigure.wooCommerce){
      API api = API();
      // body = {
      //           "billing": {
      //             "first_name": "",
      //             "last_name": "",
      //             "company": "",
      //             "address_1": "",
      //             "address_2": "",
      //             "city": "",
      //             "state": "MH",
      //             "postcode": "",
      //             "country": "IN",
      //             // "email": "john.doe@example.com",
      //             "phone":  "",
      //           },
      //           "shipping": {
      //             "first_name":"",
      //             "last_name": "",
      //             "company": "",
      //             "address_1":  "",
      //             "address_2": "",
      //             "city":"",
      //             "state": "MH",
      //             "postcode":  "",
      //             "country": "IN"
      //           }

      //         };
           
       try {
        final response;
           String cunsumerKey = AppConfigure.consumerkey;
       String cumsumerSecret = AppConfigure.consumersecret;
            debugPrint("calling null addressid api");
            // var body1 = jsonEncode({"address": body});
          response = await api.sendRequest.put(
            '/wp-json/wc/v3/customers/$uid?consumer key=$cunsumerKey&consumer secret=$cumsumerSecret',
            data: {
                "billing": {
                  "first_name": "",
                  "last_name": "",
                  "company": "",
                  "address_1": "",
                  "address_2": "",
                  "city": "",
                  "state": "",
                  "postcode": "",
                  "country": "",
                  // "email": "john.doe@example.com",
                  "phone":  "",
                },
                "shipping": {
                  "first_name":"",
                  "last_name": "",
                  "company": "",
                  "address_1":  "",
                  "address_2": "",
                  "city":"",
                  "state": "",
                  "postcode":  "",
                  "country": ""
                }

              },
            options: Options(headers: {
              'Content-Type': 'application/json',
            }),
          );

        if (response.statusCode == APIConstants.successCode) {
          debugPrint("body is this ${response.data} $uid");
           
       
            // return [DefaultAddressModel(id: response.data['id'], customerId: response.data['id'], firstName: response.data['billing']['first_name'], lastName: response.data['billing']['last_name'], address1: response.data['billing']['address_1'], city: response.data['billing']['city'], province: response.data['billing']['address_2'], country: response.data['billing']['country'], zip: response.data['billing']['postcode'], phone: response.data['billing']['phone'], name: response.data['billing']['first_name'], provinceCode: response.data['billing']['first_name'], countryCode: response.data['billing']['first_name'], countryName: response.data['billing']['first_name'], defaultAddress: false)];

          return [null];
        } else if (response.statusCode == APIConstants.dataNotFoundCode) {
          throw (AppString.noDataError);
        } else if (response.statusCode == APIConstants.unAuthorizedCode) {
          throw AppString.unAuthorized;
        } else {
          return empty;
        }
      } catch (error, stackTrace) {
        print("error for address is this $error $stackTrace");
        rethrow;
      }


      
    }
    
    
     else {
      try {
        if (await ConnectivityUtils.isNetworkConnected()) {
          final accessToken = await SharedPreferenceManager().getToken();
         final response = await api.sendRequest.post(
        "https://pyvaidyass.myshopify.com/api/2023-10/graphql.json",
        data: {
          'query': '''
         mutation {
  customerAddressDelete(customerAccessToken: "$accessToken", id: "$addId") {
    deletedCustomerAddressId
    customerUserErrors {
      field
      message
    }
  }
}
          ''',
        },
      );
          var data = jsonDecode(response.data);
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

  editAddress(Map<String, dynamic> body, String addId) async {
    String exceptionString = "";
    final uid = await SharedPreferenceManager().getUserId();
    String baseUrl = AppConfigure.baseUrl +
        APIConstants.apiForAdminURL +
        APIConstants.apiURL +
        APIConstants.customer;

    // var body1 = jsonEncode({"address": body});

    API api = API();
    if (AppConfigure.bigCommerce) {
      try {
        if (await ConnectivityUtils.isNetworkConnected()) {
          // final response = addId.isEmpty
          //     ? await ApiManager.post(
          //         "${AppConfigure.bigcommerceUrl}/customers/addresses?id:in=$uid",
          //         body)
          //     : await ApiManager.put(
          //         "${AppConfigure.bigcommerceUrl}/customers/addresses?id:in=$addId",
          //         body);

          final response;
          if (addId == "") {
            debugPrint("calling null addressid api");
            var body1 = jsonEncode({"address": body});
            response = await api.sendRequest.post(
              "/customers/addresses",
              data: [body],
              options: Options(headers: {
                'Content-Type': 'application/json',
                "X-auth-Token": AppConfigure.bigCommerceAccessToken
              }),
            );
          } else {
            debugPrint("calling not null addressid api");
            response = await api.sendRequest.put(
              "/customers/addresses",
              data: [body],
              options: Options(headers: {
                'Content-Type': 'application/json',
                "X-auth-Token": AppConfigure.bigCommerceAccessToken
              }),
            );
          }

          // var data = jsonDecode(response.body);
          if (response.statusCode == APIConstants.successCode) {
            return response;
            //    Fluttertoast.showToast(
            // msg: "customer address added successfully",
            // toastLength: Toast.LENGTH_SHORT,
            // gravity: ToastGravity.BOTTOM,
            // timeInSecForIosWeb: 0,
            // backgroundColor: AppColors.green,
            // textColor: AppColors.whiteColor,
            // fontSize: 16.0);

            // return data;
            // return AppString.success;
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
      }
      //  catch (error) {
      //   exceptionString = AppString.serverError;
      //   return exceptionString;
      // }

      on DioException catch (error) {
        if (error.response!.statusCode == APIConstants.alreadyExistCode) {
          Fluttertoast.showToast(
              msg: "${error.response!.data["errors"]}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 0,
              backgroundColor: AppColors.green,
              textColor: AppColors.whiteColor,
              fontSize: 16.0);
        }
      }
    } else if (AppConfigure.wooCommerce)
{
   try {
        if (await ConnectivityUtils.isNetworkConnected()) {
         
          final response;
           String cunsumerKey = AppConfigure.consumerkey;
       String cumsumerSecret = AppConfigure.consumersecret;
            debugPrint("calling null addressid api");
            var body1 = jsonEncode({"address": body});
          response = await api.sendRequest.put(
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
      }
      on DioException catch (error) {
        if (error.response!.statusCode == APIConstants.alreadyExistCode) {
          Fluttertoast.showToast(
              msg: "${error.response!.data["errors"]}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 0,
              backgroundColor: AppColors.green,
              textColor: AppColors.whiteColor,
              fontSize: 16.0);
        }
      }

}    
    
    else {
      try {
        if (await ConnectivityUtils.isNetworkConnected()) {
            final accessToken = await SharedPreferenceManager().getToken();
          var response;
          if (addId == "") {
            debugPrint("calling null addressid api");
            String query = '''




mutation customerAddressCreate(\$customerAccessToken: String!, \$address: MailingAddressInput!) {
  customerAddressCreate(customerAccessToken: \$customerAccessToken, address: \$address) {
    customerUserErrors {
      code
      field
      message
    }
    customerAddress {
      id
    }
  }
}


''';

            Map<String, dynamic> variables = body;

            response = await api.sendRequest.post(
              "https://pyvaidyass.myshopify.com/api/2021-04/graphql.json",
              data: {
                'query': query,
                 'variables': variables,
              },
            );
          } else {
            String city = body['address']['city'];
 debugPrint("calling null addressid api");
            String query = '''
mutation {
  customerAddressUpdate(
    customerAccessToken: "$accessToken"
    id: "$addId"
    address: {
      firstName: $body["address"]["firstName"]
      lastName:$body["address"]["lastName"]
      address1: $body["address"]["address1"]
      city: "$body["addresss"]["city"]
      province: ""
      country: $body["address"]["country"]
      zip:$body["address"]["zip"]
    }
  ) {
    customerAddress {
      id
      firstName
      lastName
      address1
      city
      province
      country
      zip
    }
    customerUserErrors {
      field
      message
    }
  }
}

''';
print(" body is here  : $body");

             Map<String, dynamic> variables = body;

            response = await api.sendRequest.post(
              "https://pyvaidyass.myshopify.com/api/2021-04/graphql.json",
              data: {
                'query': query,
                 'variables': variables,
              },
            );


          }
           print("body is this ${response.data}");
          var data = response.data;
          if (response.statusCode == APIConstants.successCode ||
              response.statusCode == APIConstants.successCreateCode) {
            print("address added successfully");
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
      } catch (error, stackTrace) {
        print('object $error $stackTrace');
        exceptionString = AppString.serverError;
        return exceptionString;
      }
    }
  }

  setDefaultAddress(String addId) async {
    String exceptionString = "";
    final uid = await SharedPreferenceManager().getUserId();
    String baseUrl = AppConfigure.baseUrl +
        APIConstants.apiForAdminURL +
        APIConstants.apiURL +
        APIConstants.customer;

    try {
      if (await ConnectivityUtils.isNetworkConnected()) {
        final response = await ApiManager.put(
            "$baseUrl$uid/${APIConstants.address}/$addId/${APIConstants.defaultAddress}.json",
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

  bigCommerceShippingAddress(Map<String, dynamic> addId) async {
    String exceptionString = "";
    final cartId = await SharedPreferenceManager().getDraftId();
    print(cartId);
    API api = API();
    try {
      if (await ConnectivityUtils.isNetworkConnected()) {
        var response = await api.sendRequest.post(
            "${AppConfigure.bigcommerceUrl}/checkouts/$cartId/billing-address",
            data: addId,
            options: Options(headers: {
              "X-auth-Token": AppConfigure.bigCommerceAccessToken,
              'Content-Type': 'application/json',
            }));
        // final response = await ApiManager.post(
        //     "${AppConfigure.bigcommerceUrl}/checkouts/$cartId/billing-address",
        //     addId);
        // var data = jsonDecode(response.body);
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
      print(error.toString());
      exceptionString = AppString.serverError;
      return exceptionString;
    }
  }
}

final addressProvider =
    Provider<AddressRepository>((ref) => AddressRepository());
