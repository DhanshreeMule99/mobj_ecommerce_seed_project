// registrationRepository


//import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:mobj_project/utils/api.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';

class RegistrationRepository {
  API api = API();
  signIn(Map<String, dynamic> body) async {
    String exceptionString = "";
    try {
      if (await ConnectivityUtils.isNetworkConnected()) {
        // final response = await http.post(
        //     Uri.parse(AppConfigure.baseUrl + APIConstants.signIn),
        //     headers: {
        //       "Content-Type": "application/json",
        //       "X-Shopify-Access-Token": AppConfigure.accessToken
        //     },
        //     body: jsonEncode({"customer": body}));
        String query = '''
             mutation RegisterAccount(
        \$email: String!, 
        \$password: String!,  
        \$firstName: String!, 
        \$lastName: String!, 
        \$acceptsMarketing: Boolean = false,
         ) {
        customerCreate(input: {
            email: \$email, 
            password: \$password, 
            firstName: \$firstName, 
            lastName: \$lastName,
            acceptsMarketing: \$acceptsMarketing, 
              }) {
            customer {
                id
            }
            customerUserErrors {
                code
                message
            }
                }
            }
            ''';
        Map<String, dynamic> variables = body;
        // {
        //   'email': 'example@example.com',
        //   'password': 'password123',
        //   'firstName': 'John',
        //   'lastName': 'Doe',
        //   'acceptsMarketing': true,
        // };

        final response = await api.sendRequest.post(APIConstants.signIn,
            data: {
              'query': query,
              'variables': variables,
            },
            options: Options(headers: {
              "X-Shopify-Storefront-Access-Token": AppConfigure.storeFrontToken
            }));

        debugPrint('status code is ${response.statusCode}');
        var data = response.data;
        if (response.statusCode == APIConstants.successCode ||
            response.statusCode == APIConstants.successCreateCode) {
          return data;
        } else if (response.statusCode == APIConstants.badRequest) {
          exceptionString = "4";
          return exceptionString;
        } else if (response.statusCode == APIConstants.conflictCode ||
            response.statusCode == APIConstants.alreadyExistCode) {
          var data = response.data;
          if (data["errors"] != null) {
            if (data["errors"]["email"] != null) {
              if (data["errors"]["email"].toString() == "[is invalid]") {
                exceptionString = AppString.emailValidationMsg;
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
