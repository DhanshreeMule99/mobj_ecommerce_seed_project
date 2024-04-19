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
