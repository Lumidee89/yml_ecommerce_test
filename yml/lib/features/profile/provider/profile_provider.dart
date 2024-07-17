import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/data/model/api_response.dart';
import 'package:yml_ecommerce_test/data/model/response_model.dart';
import 'package:yml_ecommerce_test/features/profile/domain/model/user_info_model.dart';
import 'package:yml_ecommerce_test/features/profile/domain/repo/profile_repo.dart';
import 'package:yml_ecommerce_test/helper/api_checker.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/main.dart';
import 'package:yml_ecommerce_test/basewidget/show_custom_snakbar.dart';
import 'package:http/http.dart' as http;


class ProfileProvider extends ChangeNotifier {
  final ProfileRepo? profileRepo;
  ProfileProvider({required this.profileRepo});


  UserInfoModel? _userInfoModel;
  bool _isLoading = false;
  bool _isDeleting = false;
  bool get isDeleting => _isDeleting;
  double? _balance;
  double? get balance =>_balance;
  UserInfoModel? get userInfoModel => _userInfoModel;
  bool get isLoading => _isLoading;





  double? loyaltyPoint = 0;
  String userID = '-1';
  Future<String> getUserInfo(BuildContext context) async {
    ApiResponse apiResponse = await profileRepo!.getUserInfo();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _userInfoModel = UserInfoModel.fromJson(apiResponse.response!.data);
      userID = _userInfoModel!.id.toString();
      _balance = _userInfoModel?.walletBalance?? 0;
      loyaltyPoint = _userInfoModel?.loyaltyPoint?? 0;
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
    return userID;
  }


  Future<ApiResponse> deleteCustomerAccount(BuildContext context, int? customerId) async {
    _isDeleting = true;
    notifyListeners();
    ApiResponse apiResponse = await profileRepo!.deleteUserAccount(customerId);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _isLoading = false;
      Map map = apiResponse.response!.data;
      String message = map ['message'];
      showCustomSnackBar(message, Get.context!, isError: false);

    } else {
      _isLoading = false;
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }






  Future<ResponseModel> updateUserInfo(UserInfoModel updateUserModel, String pass, File? file, String token) async {
    _isLoading = true;
    notifyListeners();

    ResponseModel responseModel;
    http.StreamedResponse response = await profileRepo!.updateProfile(updateUserModel, pass, file, token);
    _isLoading = false;
    if (response.statusCode == 200) {
      Map map = jsonDecode(await response.stream.bytesToString());
      String? message = map["message"];
      _userInfoModel = updateUserModel;
      responseModel = ResponseModel(message, true);
    } else {
      if (kDebugMode) {
        print('${response.statusCode} ${response.reasonPhrase}');
      }
      responseModel = ResponseModel('${response.statusCode} ${response.reasonPhrase}', false);
    }
    notifyListeners();
    return responseModel;
  }


  Future<ApiResponse> contactUs(String name, String email, String phone, String subject, String message) async {
    _isDeleting = true;
    notifyListeners();
    ApiResponse apiResponse = await profileRepo!.contactUs(name, email, phone, subject, message);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _isLoading = false;
     showCustomSnackBar('${getTranslated('message_sent_successfully', Get.context!)}', Get.context!, isError: false);
    } else {
      _isLoading = false;
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

}
