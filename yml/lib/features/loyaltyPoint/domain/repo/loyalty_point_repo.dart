import 'package:dio/dio.dart';
import 'package:yml_ecommerce_test/data/datasource/remote/dio/dio_client.dart';
import 'package:yml_ecommerce_test/data/datasource/remote/exception/api_error_handler.dart';
import 'package:yml_ecommerce_test/data/model/api_response.dart';
import 'package:yml_ecommerce_test/utill/app_constants.dart';

class LoyaltyPointRepo {
  final DioClient? dioClient;
  LoyaltyPointRepo({required this.dioClient});


  Future<ApiResponse> getLoyaltyPointList(int offset) async {
    try {
      Response response = await dioClient!.get('${AppConstants.loyaltyPointUri}$offset');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> convertPointToCurrency(int point) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.loyaltyPointConvert,
        data: {"point": point},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}