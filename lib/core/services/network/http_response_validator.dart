import 'dart:developer';
import 'package:dio/dio.dart';

class ResponseValidator {
  static isValidResponse(Response response) {
    if (response.data != null &&
        [200, 201, 202, 203, 204].contains(response.statusCode)) {
      log(' Valid response 🌎 ✔ 🌏 ✔ : ${response.statusCode}');
      return true;
    }
    return false;
  }
}