import 'dart:convert';

import 'package:dio/dio.dart';

final Dio _dio = Dio();

class GenericResponse {
  late int statusCode;
  String? validationError;

  GenericResponse(this.statusCode, [this.validationError]);

  GenericResponse.fromResponse(Response response) {
    statusCode = response.statusCode!;
  }
}

class LoginResponse extends GenericResponse {
  String? accessToken;
  String? refreshToken;

  LoginResponse(statusCode, this.accessToken, this.refreshToken)
      : super(statusCode);

  String toJson() {
    return jsonEncode({
      'response_status': this.statusCode,
      'access_token': this.accessToken,
      'refresh_token': this.refreshToken
    });
  }
}

Map<String, Function> apiMethods = {
  'login': (Map<String, dynamic> args) async {
    Response response = await _dio.post(
      "https://api.very.supply/moses/token/obtain/",
      data: args,
      options: Options(validateStatus: (status) => status! < 500),
    );
    return LoginResponse(
        response.statusCode, response.data['access'], response.data['refresh']);
  }
};
