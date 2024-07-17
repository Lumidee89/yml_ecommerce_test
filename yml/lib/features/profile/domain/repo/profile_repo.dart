import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:yml_ecommerce_test/data/datasource/remote/dio/dio_client.dart';
import 'package:yml_ecommerce_test/data/datasource/remote/exception/api_error_handler.dart';
import 'package:yml_ecommerce_test/data/model/api_response.dart';
import 'package:yml_ecommerce_test/features/profile/domain/model/user_info_model.dart';
import 'package:yml_ecommerce_test/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  ProfileRepo({required this.dioClient, required this.sharedPreferences});



  Future<ApiResponse> getUserInfo() async {
    try {
      final response = await dioClient!.get(AppConstants.customerUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> deleteUserAccount(int? customerId) async {
    try {
      final response = await dioClient!.get('${AppConstants.deleteCustomerAccount}/$customerId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }




  Future<http.StreamedResponse> updateProfile(UserInfoModel userInfoModel, String pass, File? file, String token) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.updateProfileUri}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});
    if(file != null){
      request.files.add(http.MultipartFile('image', file.readAsBytes().asStream(), file.lengthSync(), filename: file.path.split('/').last));
    }
     Map<String, String> fields = {};
    if(pass.isEmpty) {
      fields.addAll(<String, String>{
        '_method': 'put', 'f_name': userInfoModel.fName!, 'l_name': userInfoModel.lName!, 'phone': userInfoModel.phone!
      });
    }else {
      fields.addAll(<String, String>{
        '_method': 'put', 'f_name': userInfoModel.fName!, 'l_name': userInfoModel.lName!, 'phone': userInfoModel.phone!, 'password': pass
      });
    }
    request.fields.addAll(fields);
    if (kDebugMode) {
      print('========>${fields.toString()}');
    }
    http.StreamedResponse response = await request.send();
    return response;
  }

  Future<ApiResponse> contactUs(String name, String email, String phone, String subject, String message) async {
    try {
      final response = await dioClient!.post(AppConstants.contactUsUri,
      data: {
        "name" :name,
        "email" : email,
        "mobile_number" : phone,
        "subject" : subject,
        "message" : message
      });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}
