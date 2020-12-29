import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:grocery_app/config.dart';
import 'package:grocery_app/models/customer.dart';

class ApiService {
  Future<bool> CreateCustomer(CustomerModel model) async {
    var authToken = base64
        .encode(utf8.encode(Config.consumerKey + ':' + Config.consumerSecret));

     bool ret = false;

    try {
      var response = await Dio().post(Config.url + Config.customerUrl,
          data: model.toJson(),
          options: new Options(headers: {
            HttpHeaders.authorizationHeader: 'Basic $authToken',
            HttpHeaders.contentTypeHeader: 'Application/json'
          }));
      print("*****statuscode*****");
        print(response.statusCode);
      if (response.statusCode == 201) {
        ret = true;
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 404) {
        ret = false;
      } else {
        ret = false;
      }
    }
    return ret;
  }
}
