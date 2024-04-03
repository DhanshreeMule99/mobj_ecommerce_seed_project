import 'package:dio/dio.dart';

import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'appConfiguer.dart';



class API {
  final Dio _dio = Dio();

  API() {
    _dio.options.baseUrl = AppConfigure.baseUrl;
    _dio.interceptors.add(PrettyDioLogger());
  }

  Dio get sendRequest => _dio;
}
