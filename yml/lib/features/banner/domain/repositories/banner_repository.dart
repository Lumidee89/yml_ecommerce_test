import 'package:yml_ecommerce_test/data/datasource/remote/dio/dio_client.dart';
import 'package:yml_ecommerce_test/data/datasource/remote/exception/api_error_handler.dart';
import 'package:yml_ecommerce_test/data/model/api_response.dart';
import 'package:yml_ecommerce_test/features/banner/domain/repositories/contracts/banner_repository_interface.dart';
import 'package:yml_ecommerce_test/utill/app_constants.dart';

class BannerRepository implements BannerRepositoryInterface{
  final DioClient? dioClient;
  BannerRepository({required this.dioClient});

  @override
  Future<ApiResponse> get() async {
    try {
      final response = await dioClient!.get(AppConstants.getBannerList);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> add(Map<String, dynamic> body) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse> delete() {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse> deleteById(String id) {
    // TODO: implement deleteById
    throw UnimplementedError();
  }


  @override
  Future<ApiResponse> getById(String id) {
    // TODO: implement getById
    throw UnimplementedError();
  }



  @override
  Future<ApiResponse> update(Map<String, dynamic> body) {
    // TODO: implement update
    throw UnimplementedError();
  }
}