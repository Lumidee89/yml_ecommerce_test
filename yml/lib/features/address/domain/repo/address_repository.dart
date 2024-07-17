import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/data/datasource/remote/dio/dio_client.dart';
import 'package:yml_ecommerce_test/data/datasource/remote/exception/api_error_handler.dart';
import 'package:yml_ecommerce_test/features/address/domain/model/address_model.dart';
import 'package:yml_ecommerce_test/data/model/api_response.dart';
import 'package:yml_ecommerce_test/features/auth/controllers/auth_controller.dart';
import 'package:yml_ecommerce_test/main.dart';
import 'package:yml_ecommerce_test/utill/app_constants.dart';
import 'package:yml_ecommerce_test/utill/images.dart';
import 'package:provider/provider.dart';


class AddressRepository {
  final DioClient? dioClient;
  AddressRepository({this.dioClient, });


  Future<ApiResponse> getDeliveryRestrictedCountryList() async {
    try {
      final response = await dioClient!.get(AppConstants.deliveryRestrictedCountryList);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getDeliveryRestrictedZipList() async {
    try {
      final response = await dioClient!.get(AppConstants.deliveryRestrictedZipList);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getDeliveryRestrictedZipBySearch(String zipcode) async {
    try {
      final response = await dioClient!.get('${AppConstants.deliveryRestrictedZipList}?search=$zipcode');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getDeliveryRestrictedCountryBySearch(String country) async {
    try {
      final response = await dioClient!.get('${AppConstants.deliveryRestrictedCountryList}?search=$country');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponse> getAddressTypeList() async {
    try {
      List<String> addressTypeList = [
        'Select Address type',
        'Permanent',
        'Home',
        'Office',
      ];
      Response response = Response(requestOptions: RequestOptions(path: ''),
          data: addressTypeList, statusCode: 200);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponse> getAllAddress() async {
    try {
      final response = await dioClient!.get('${AppConstants.addressListUri}?guest_id=${Provider.of<AuthController>(Get.context!, listen: false).getGuestToken()}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> removeAddressByID(int? id) async {
    try {
      final response = await dioClient!.delete('${AppConstants.removeAddressUri}?address_id=$id&guest_id=${Provider.of<AuthController>(Get.context!, listen: false).getGuestToken()}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponse> addAddress(AddressModel addressModel) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.addAddressUri,
        data: addressModel.toJson(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updateAddress(AddressModel addressModel, int? addressId) async {
    try {
      Response response = await dioClient!.post(
        '${AppConstants.updateAddressUri}$addressId',
        data: addressModel.toJson(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  List<LabelAsModel> getAllAddressType({BuildContext? context}) {
    List<LabelAsModel> labelAsList= [
      LabelAsModel('home', Images.homeImage),
      LabelAsModel('office', Images.officeImage),
      LabelAsModel('others', Images.address),
    ];
    return labelAsList;
  }
}


class LabelAsModel{
  String title;
  String icon;

  LabelAsModel(this.title, this.icon);
}