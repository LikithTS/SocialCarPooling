import 'dart:developer';

import 'package:common/network/apiclient.dart';
import 'package:common/network/model/error_response.dart';
import 'package:common/network/request/loginapi.dart';
import 'package:common/network/response/LoginResponse.dart';
import 'package:common/network/response/SuccessResponse.dart';
import 'package:dio/dio.dart';

class LoginRepository{

  Future<dynamic> login({required LoginApi api}) async {
    Response userData = await APIClient().getDioInstance()
        .post("/user/login", data: api.toJson());
    if (userData.statusCode == 200) {
      try {
        var successResponse = SuccessResponse.fromJson(userData.data);
        if (successResponse.status == 200) {
          var responseJson = successResponse.responseData![0];
          var loginResponse = LoginResponse.fromJson(responseJson);
          log("legionaries: $loginResponse");
          return loginResponse;
        } else {
          return ErrorResponse.fromJson(userData.data);
        }
      } catch (e) {
        log("Error:$e");
      }
    } else {
      return ErrorResponse.fromJson(userData.data);
    }
  }
}