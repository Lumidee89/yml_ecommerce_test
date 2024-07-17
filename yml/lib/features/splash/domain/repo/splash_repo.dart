import 'package:yml_ecommerce_test/data/datasource/remote/dio/dio_client.dart';
import 'package:yml_ecommerce_test/data/datasource/remote/exception/api_error_handler.dart';
import 'package:yml_ecommerce_test/data/model/api_response.dart';
import 'package:yml_ecommerce_test/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  SplashRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> getConfig() async {
    try {
      final response = await dioClient!.get(AppConstants.configUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  void initSharedData() async {
    if (!sharedPreferences!.containsKey(AppConstants.intro)) {
      sharedPreferences!.setBool(AppConstants.intro, true);
    }
    if (!sharedPreferences!.containsKey(AppConstants.currency)) {
      sharedPreferences!.setString(AppConstants.currency, '');
    }
  }

  String getCurrency() {
    return sharedPreferences!.getString(AppConstants.currency) ?? '';
  }

  void setCurrency(String currencyCode) {
    sharedPreferences!.setString(AppConstants.currency, currencyCode);
  }

  void disableIntro() {
    sharedPreferences!.setBool(AppConstants.intro, false);
  }

  bool? showIntro() {
    return sharedPreferences!.getBool(AppConstants.intro);
  }
}
