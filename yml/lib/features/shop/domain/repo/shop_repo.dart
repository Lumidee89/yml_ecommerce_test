import 'package:yml_ecommerce_test/data/datasource/remote/dio/dio_client.dart';
import 'package:yml_ecommerce_test/data/datasource/remote/exception/api_error_handler.dart';
import 'package:yml_ecommerce_test/data/model/api_response.dart';
import 'package:yml_ecommerce_test/utill/app_constants.dart';

class SellerRepo {
  final DioClient? dioClient;
  SellerRepo({required this.dioClient});

  Future<ApiResponse> getSeller(String sellerId) async {
    try {
      final response = await dioClient!.get(AppConstants.sellerUri+sellerId);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  Future<ApiResponse> getMoreStore() async {
    try {
      final response = await dioClient!.get(AppConstants.moreStore);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}