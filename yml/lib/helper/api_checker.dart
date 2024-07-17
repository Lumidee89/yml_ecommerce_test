import 'dart:developer';

import 'package:yml_ecommerce_test/data/model/api_response.dart';
import 'package:yml_ecommerce_test/data/model/error_response.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/main.dart';
import 'package:yml_ecommerce_test/features/auth/controllers/auth_controller.dart';
import 'package:yml_ecommerce_test/basewidget/show_custom_snakbar.dart';
import 'package:provider/provider.dart';

class ApiChecker {
  static void checkApi(ApiResponse apiResponse) {
    print('got herezz');
    if (apiResponse.error == "Failed to load data - status code: 401") {
      Provider.of<AuthController>(Get.context!, listen: false)
          .clearSharedData();
    } else if (apiResponse.response?.statusCode == 500) {
      showCustomSnackBar(
          getTranslated('internal_server_error', Get.context!), Get.context!);
    } else {
      log("==ff=>${apiResponse.error}");
      String? errorMessage = apiResponse.error.toString();
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
        print('got here');
        print(errorMessage);
      } else {
        ErrorResponse errorResponse = ErrorResponse.fromJson(apiResponse.error);
        log(errorResponse.toString());
        //errorMessage = errorResponse.errors?[0].message;
      }
      showCustomSnackBar(errorMessage, Get.context!);
    }
  }
}
