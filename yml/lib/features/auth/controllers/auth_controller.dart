import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/features/auth/domain/models/login_model.dart';
import 'package:yml_ecommerce_test/features/auth/domain/models/register_model.dart';
import 'package:yml_ecommerce_test/data/model/api_response.dart';
import 'package:yml_ecommerce_test/data/model/error_response.dart';
import 'package:yml_ecommerce_test/data/model/response_model.dart';
import 'package:yml_ecommerce_test/features/auth/domain/models/social_login_model.dart';
import 'package:yml_ecommerce_test/features/auth/domain/repositories/auth_repository.dart';
import 'package:yml_ecommerce_test/features/auth/views/auth_screen.dart';
import 'package:yml_ecommerce_test/helper/api_checker.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/main.dart';
import 'package:yml_ecommerce_test/localization/provider/localization_provider.dart';
import 'package:yml_ecommerce_test/basewidget/show_custom_snakbar.dart';
import 'package:provider/provider.dart';

class AuthController with ChangeNotifier {
  final AuthRepository? authRepo;
  AuthController({required this.authRepo});

  bool _isLoading = false;
  bool? _isRemember = false;
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  String countryDialCode = '+880';
  void setCountryCode(String countryCode, {bool notify = true}) {
    countryDialCode = countryCode;
    if (notify) {
      notifyListeners();
    }
  }

  updateSelectedIndex(int index, {bool notify = true}) {
    _selectedIndex = index;
    if (notify) {
      notifyListeners();
    }
  }

  bool get isLoading => _isLoading;
  bool? get isRemember => _isRemember;

  void updateRemember() {
    _isRemember = !_isRemember!;
    notifyListeners();
  }

  Future<void> socialLogin(
      SocialLoginModel socialLogin, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authRepo!.socialLogin(socialLogin.toJson());
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isLoading = false;
      Map map = apiResponse.response!.data;
      String? message = '', token = '', temporaryToken = '';
      try {
        message = map['error_message'];
      } catch (e) {
        //
      }
      try {
        token = map['token'];
      } catch (e) {
        //
      }
      try {
        temporaryToken = map['temporary_token'];
      } catch (e) {
        //
      }
      if (token != null) {
        authRepo!.saveUserToken(token);
        await authRepo!.updateDeviceToken();
        setCurrentLanguage(
            Provider.of<LocalizationProvider>(Get.context!, listen: false)
                    .getCurrentLanguage() ??
                'en');
      }
      callback(true, token, temporaryToken, message);
    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future registration(RegisterModel register, Function callback) async {
    _isLoading = true;
    print('got herezzz');
    notifyListeners();
    ApiResponse apiResponse = await authRepo!.registration(register.toJson());
    _isLoading = false;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      String? temporaryToken = '', token = '', message = '';
      try {
        message = map["message"];
      } catch (e) {
        //
      }
      try {
        token = map["token"];
      } catch (e) {
        //
      }
      try {
        temporaryToken = map["temporary_token"];
      } catch (e) {
        //
      }
      if (token != null && token.isNotEmpty) {
        authRepo!.saveUserToken(token);
        await authRepo!.updateDeviceToken();
      }
      callback(true, token, temporaryToken, message);
      notifyListeners();
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future logOut() async {
    ApiResponse apiResponse = await authRepo!.logout();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {}
  }

  Future<void> setCurrentLanguage(String currentLanguage) async {
    ApiResponse apiResponse =
        await authRepo!.setLanguageCode(currentLanguage.toLowerCase());
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {}
  }

  Future<void> login(LoginModel loginBody, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authRepo!.login(loginBody.toJson());
    _isLoading = false;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      clearGuestId();
      Map map = apiResponse.response!.data;
      String? temporaryToken = '', token = '', message = '';
      try {
        message = map["message"];
      } catch (e) {
        //
      }
      try {
        token = map["token"];
      } catch (e) {
        //
      }
      try {
        temporaryToken = map["temporary_token"];
      } catch (e) {
        //
      }

      if (token != null && token.isNotEmpty) {
        authRepo!.saveUserToken(token);
        await authRepo!.updateDeviceToken();
        setCurrentLanguage(
            Provider.of<LocalizationProvider>(Get.context!, listen: false)
                    .getCurrentLanguage() ??
                'en');
      }
      callback(true, token, temporaryToken, message);
      notifyListeners();
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> updateToken(BuildContext context) async {
    ApiResponse apiResponse = await authRepo!.updateDeviceToken();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
    } else {
      ApiChecker.checkApi(apiResponse);
    }
  }

  Future<ApiResponse> sendOtpToEmail(String email, String temporaryToken,
      {bool resendOtp = false}) async {
    _isPhoneNumberVerificationButtonLoading = true;
    _verificationMsg = '';
    notifyListeners();
    ApiResponse apiResponse;
    if (resendOtp) {
      apiResponse = await authRepo!.resendEmailOtp(email, temporaryToken);
    } else {
      apiResponse = await authRepo!.sendOtpToEmail(email, temporaryToken);
    }
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      resendTime = (apiResponse.response!.data["resend_time"]);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  Future<ResponseModel> verifyEmail(String email, String token) async {
    _isPhoneNumberVerificationButtonLoading = true;
    _verificationMsg = '';
    notifyListeners();
    ApiResponse apiResponse =
        await authRepo!.verifyEmail(email, _verificationCode, token);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      authRepo!.saveUserToken(apiResponse.response!.data['token']);
      await authRepo!.updateDeviceToken();
      responseModel = ResponseModel('Successful', true);
    } else {
      String? errorMessage;
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        errorMessage = errorResponse.errors![0].message;
      }
      responseModel = ResponseModel(errorMessage, false);
      _verificationMsg = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }

  int resendTime = 0;

  Future<ResponseModel> sendOtpToPhone(String phone, String temporaryToken,
      {bool fromResend = false}) async {
    _isPhoneNumberVerificationButtonLoading = true;
    _verificationMsg = '';
    notifyListeners();
    ApiResponse apiResponse;
    if (fromResend) {
      apiResponse = await authRepo!.resendPhoneOtp(phone, temporaryToken);
    } else {
      apiResponse = await authRepo!.sendOtpToPhone(phone, temporaryToken);
    }
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      responseModel = ResponseModel(apiResponse.response!.data["token"], true);
      resendTime = (apiResponse.response!.data["resend_time"]);
    } else {
      String? errorMessage;
      if (apiResponse.error is String) {
        if (kDebugMode) {
          print(apiResponse.error.toString());
        }
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        if (kDebugMode) {
          print('=error==${errorResponse.errors![0].message}');
        }
        errorMessage = errorResponse.errors![0].message;
      }
      responseModel = ResponseModel(errorMessage, false);
      _verificationMsg = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ApiResponse> verifyPhone(String phone, String token) async {
    _isPhoneNumberVerificationButtonLoading = true;
    _verificationMsg = '';
    notifyListeners();
    ApiResponse apiResponse =
        await authRepo!.verifyPhone(phone, token, _verificationCode);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
    } else {
      _isPhoneNumberVerificationButtonLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  Future<ApiResponse> verifyOtpForResetPassword(String phone) async {
    _isPhoneNumberVerificationButtonLoading = true;
    _verificationMsg = '';
    notifyListeners();

    ApiResponse apiResponse =
        await authRepo!.verifyOtp(phone, _verificationCode);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
    } else {
      _isPhoneNumberVerificationButtonLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  Future<ApiResponse> resetPassword(String identity, String otp,
      String password, String confirmPassword) async {
    _isPhoneNumberVerificationButtonLoading = true;
    _verificationMsg = '';
    notifyListeners();
    ApiResponse apiResponse =
        await authRepo!.resetPassword(identity, otp, password, confirmPassword);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      showCustomSnackBar(
          getTranslated('password_reset_successfully', Get.context!),
          Get.context!);
      Navigator.pushAndRemoveUntil(
          Get.context!,
          MaterialPageRoute(builder: (_) => const AuthScreen()),
          (route) => false);
    } else {
      _isPhoneNumberVerificationButtonLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  // for phone verification
  bool _isPhoneNumberVerificationButtonLoading = false;
  bool get isPhoneNumberVerificationButtonLoading =>
      _isPhoneNumberVerificationButtonLoading;
  String? _verificationMsg = '';
  String? get verificationMessage => _verificationMsg;
  String _email = '';
  String _phone = '';

  String get email => _email;
  String get phone => _phone;

  updateEmail(String email) {
    _email = email;
    notifyListeners();
  }

  updatePhone(String phone) {
    _phone = phone;
    notifyListeners();
  }

  void clearVerificationMessage() {
    _verificationMsg = '';
  }

  String _verificationCode = '';
  String get verificationCode => _verificationCode;
  bool _isEnableVerificationCode = false;
  bool get isEnableVerificationCode => _isEnableVerificationCode;

  updateVerificationCode(String query) {
    if (query.length == 4) {
      _isEnableVerificationCode = true;
    } else {
      _isEnableVerificationCode = false;
    }
    _verificationCode = query;
    notifyListeners();
  }

  String getUserToken() {
    return authRepo!.getUserToken();
  }

  String? getGuestToken() {
    return authRepo!.getGuestIdToken();
  }

  bool isLoggedIn() {
    return authRepo!.isLoggedIn();
  }

  bool isGuestIdExist() {
    return authRepo!.isGuestIdExist();
  }

  Future<bool> clearSharedData() {
    return authRepo!.clearSharedData();
  }

  Future<bool> clearGuestId() async {
    return await authRepo!.clearGuestId();
  }

  void saveUserEmail(String email, String password) {
    authRepo!.saveUserEmailAndPassword(email, password);
  }

  String getUserEmail() {
    return authRepo!.getUserEmail();
  }

  Future<bool> clearUserEmailAndPassword() async {
    return authRepo!.clearUserEmailAndPassword();
  }

  String getUserPassword() {
    return authRepo!.getUserPassword();
  }

  Future<ApiResponse> forgetPassword(String email) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse =
        await authRepo!.forgetPassword(email.replaceAll('+', ''));
    _isLoading = false;

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      showCustomSnackBar(apiResponse.response?.data['message'], Get.context!,
          isError: false);
    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  Future<void> getGuestIdUrl() async {
    ApiResponse apiResponse = await authRepo!.getGuestId();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      authRepo?.saveGuestId(apiResponse.response!.data['guest_id'].toString());
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }
}
