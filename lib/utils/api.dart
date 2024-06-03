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
      _dio.options.headers["Accept"] = "application/json";
      _dio.options.headers["Authorization"] =
          "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJjaWQiOjEsImNvcnMiOltdLCJlYXQiOjE4ODU2MzUxNzYsImlhdCI6MTcxNzQwMDA2OCwiaXNzIjoiQkMiLCJzaWQiOjEwMDMxOTU4NzksInN1YiI6ImdoZjluNm4wMm52OWhma3UydmIxdmpyZGpscHNxaGsiLCJzdWJfdHlwZSI6MiwidG9rZW5fdHlwZSI6MX0.gE7hLbCd0_wkdVK0CoAmu5j2RjKbQmHm8y98AiL1tzDrBix59VOCml27tEgnbXaglcMCGbYwnPd0enBbSy_bcw";
    } else if (AppConfigure.wooCommerce) {
      _dio.options.headers["Content-Type"] = "application/json";
    } else if (AppConfigure.megentoCommerce) {
      // String? token = AppConfigure.accessToken;
      // String storeFrontToken = AppConfigure.storeFrontToken ?? "";

      // _dio.options.headers['X-Shopify-Access-Token'] = token;
      // _dio.options.headers['X-Shopify-Storefront-Access-Token'] =
      //     storeFrontToken;
      _dio.options.headers['Content-Type'] = 'application/json';
      // _dio.options.headers["Authorization"] =
      //     "Bearer 7iqu2oq5y7oruxwdf9fzksf7ak16cfri";
      // _dio.options.headers['SECRET-KEY'] = AppConfigure.feraSecretKey;
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
