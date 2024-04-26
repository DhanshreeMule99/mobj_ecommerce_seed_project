import 'package:dio/dio.dart';

import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'appConfiguer.dart';

class API {
  final Dio _dio = Dio();

  API() {
    _dio.options.baseUrl = AppConfigure.baseUrl;
    _dio.interceptors.add(PrettyDioLogger());

    if (AppConfigure.bigCommerce) {
      _dio.options.headers["X-auth-Token"] =
          AppConfigure.bigCommerceAccessToken;
      _dio.options.headers["Content-Type"] = "application/json";
      _dio.options.headers["Authorization"] = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJjaWQiOjEsImNvcnMiOltdLCJlYXQiOjE4ODU2MzUxNzYsImlhdCI6MTcxMzUxMTc0NiwiaXNzIjoiQkMiLCJzaWQiOjEwMDMxNjM0NTUsInN1YiI6Imp6OGtmamtrOHVpeW9xa2RyZHMwa2UwdTk5Y2cxazEiLCJzdWJfdHlwZSI6MiwidG9rZW5fdHlwZSI6MX0.4Fk0-S_YTp1oOjk0wftA501ecRPHIGH2jdfD1TcfJlqQ4uUa1rGrHmzuxKC35Cnao389Vx17X2Ass5xrDJekQA";
     }
      else if (AppConfigure.wooCommerce){

    //   _dio.options.queryParameters["consumer key"] = "ck_db1d729eb2978c28ae46451d36c1ca02da112cb3" ;
    //   _dio.options.queryParameters["consumer secret"] = "cs_c5cc06675e8ffa375b084acd40987fec142ec8cf";
    //  _dio.options.headers["Content-Type"] = "application/json";
    }
    else 
     {
      String? token = AppConfigure.accessToken;
      String  storeFrontToken = AppConfigure.storeFrontToken ?? "";

      _dio.options.headers['X-Shopify-Access-Token'] = token;
      _dio.options.headers['X-Shopify-Storefront-Access-Token'] =
          storeFrontToken;
      _dio.options.headers['Content-Type'] = 'application/json';
      _dio.options.headers['SECRET-KEY'] = AppConfigure.feraSecretKey;
    }
  }

  Dio get sendRequest => _dio;
}