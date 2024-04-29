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
      _dio.options.headers["Authorization"] =
          "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJjaWQiOjEsImNvcnMiOltdLCJlYXQiOjE4ODU2MzUxNzYsImlhdCI6MTcxNDM3MDYzOCwiaXNzIjoiQkMiLCJzaWQiOjEwMDMxNzY2NzAsInN1YiI6ImVlNnhnaGJ4cGhsOXo2YWJ0ZnBianV5cHZleXc4dmEiLCJzdWJfdHlwZSI6MiwidG9rZW5fdHlwZSI6MX0.bWEytInFAdEWvJjSHj0DXZVucxrQ5IrYPaPI4_NTxNjGpuFtHOBuvim3CMrE1YDT_gUborL5aHo8cC338gO3OA";
    } else if (AppConfigure.wooCommerce) {
      _dio.options.queryParameters["consumer key"] =
          "ck_8cab567f1391d7044d88564e4b932accbb6a560b";
      _dio.options.queryParameters["consumer secret"] =
          "cs_3317a4f8d9fc8cc462dca3c059f3f0ff452553ae";
      _dio.options.headers["Content-Type"] = "application/json";
    } else {
      String? token = AppConfigure.accessToken;
      String storeFrontToken = AppConfigure.storeFrontToken ?? "";

      _dio.options.headers['X-Shopify-Access-Token'] = token;
      _dio.options.headers['X-Shopify-Storefront-Access-Token'] =
          storeFrontToken;
      _dio.options.headers['Content-Type'] = 'application/json';
      _dio.options.headers['SECRET-KEY'] = AppConfigure.feraSecretKey;
    }
  }

  Dio get sendRequest => _dio;
}
