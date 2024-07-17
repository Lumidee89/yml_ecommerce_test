import 'package:flutter/foundation.dart';
import 'package:yml_ecommerce_test/data/model/api_response.dart';
import 'package:yml_ecommerce_test/data/model/error_response.dart';
import 'package:yml_ecommerce_test/features/checkout/domain/repo/checkout_repo.dart';
import 'package:yml_ecommerce_test/features/offline_payment/domain/model/offline_payment_model.dart';
import 'package:yml_ecommerce_test/features/cart/domain/models/shipping_method_model.dart';
import 'package:yml_ecommerce_test/helper/api_checker.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/main.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/basewidget/show_custom_snakbar.dart';
import 'package:yml_ecommerce_test/features/checkout/view/digital_payment_order_place.dart';

class CheckOutProvider with ChangeNotifier {
  final CheckOutRepo checkOutRepo;
  CheckOutProvider({required this.checkOutRepo});

  int? _addressIndex;
  int? _billingAddressIndex;
  int? get billingAddressIndex => _billingAddressIndex;
  int? _shippingIndex;
  bool _isLoading = false;
  List<ShippingMethodModel>? _shippingList;
  int _paymentMethodIndex = -1;
  bool _onlyDigital = true;
  bool get onlyDigital => _onlyDigital;
  int? get addressIndex => _addressIndex;
  int? get shippingIndex => _shippingIndex;
  bool get isLoading => _isLoading;
  List<ShippingMethodModel>? get shippingList => _shippingList;
  int get paymentMethodIndex => _paymentMethodIndex;

  String selectedPaymentName = '';
  void setSelectedPayment(String payment) {
    selectedPaymentName = payment;
    notifyListeners();
  }

  final TextEditingController orderNoteController = TextEditingController();

  List<String> inputValueList = [];
  Future<void> placeOrder(
      {required Function callback,
      String? addressID,
      String? couponCode,
      String? couponAmount,
      String? billingAddressId,
      String? orderNote,
      String? transactionId,
      String? paymentNote,
      int? id,
      String? name,
      bool isfOffline = false,
      bool wallet = false}) async {
    for (TextEditingController textEditingController
        in inputFieldControllerList) {
      inputValueList.add(textEditingController.text.trim());
    }
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse;
    isfOffline
        ? apiResponse = await checkOutRepo.offlinePaymentPlaceOrder(
            addressID,
            couponCode,
            couponAmount,
            billingAddressId,
            orderNote,
            keyList,
            inputValueList,
            offlineMethodSelectedId,
            offlineMethodSelectedName,
            paymentNote)
        : wallet
            ? apiResponse = await checkOutRepo.walletPaymentPlaceOrder(
                addressID,
                couponCode,
                couponAmount,
                billingAddressId,
                orderNote)
            : apiResponse = await checkOutRepo.placeOrder(addressID, couponCode,
                couponAmount, billingAddressId, orderNote);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isLoading = false;
      _addressIndex = null;
      _billingAddressIndex = null;

      String message = apiResponse.response!.data.toString();
      callback(true, message, '');
    } else {
      _isLoading = false;
      String? errorMessage;
      if (apiResponse.error is String) {
        if (kDebugMode) {
          print(apiResponse.error.toString());
        }
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        if (kDebugMode) {
          print(errorResponse.errors![0].message);
        }
        errorMessage = errorResponse.errors![0].message;
      }
      callback(false, errorMessage, '-1');
    }
    notifyListeners();
  }

  void stopLoader({bool notify = true}) {
    _isLoading = false;
    if (notify) {
      notifyListeners();
    }
  }

  void setAddressIndex(int index) {
    _addressIndex = index;
    notifyListeners();
  }

  void setBillingAddressIndex(int index) {
    _billingAddressIndex = index;
    notifyListeners();
  }

  void resetPaymentMethod() {
    _paymentMethodIndex = -1;
    codChecked = false;
    walletChecked = false;
    offlineChecked = false;
  }

  Future<void> initShippingList(BuildContext context, int sellerID) async {
    _paymentMethodIndex = 0;
    _shippingIndex = null;
    _addressIndex = null;
    ApiResponse apiResponse = await checkOutRepo.getShippingMethod(sellerID);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _shippingList = [];
      apiResponse.response!.data.forEach((shippingMethod) =>
          _shippingList!.add(ShippingMethodModel.fromJson(shippingMethod)));
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  void shippingAddressNull() {
    _addressIndex = null;
    notifyListeners();
  }

  void billingAddressNull() {
    _billingAddressIndex = null;
    notifyListeners();
  }

  void setSelectedShippingAddress(int index) {
    _shippingIndex = index;
    notifyListeners();
  }

  void setSelectedBillingAddress(int index) {
    _billingAddressIndex = index;
    notifyListeners();
  }

  bool offlineChecked = false;
  bool codChecked = false;
  bool walletChecked = false;

  void setOfflineChecked(String type) {
    if (type == 'offline') {
      offlineChecked = !offlineChecked;
      codChecked = false;
      walletChecked = false;
      _paymentMethodIndex = -1;
      setOfflinePaymentMethodSelectedIndex(0);
    } else if (type == 'cod') {
      codChecked = !codChecked;
      offlineChecked = false;
      walletChecked = false;
      _paymentMethodIndex = -1;
    } else if (type == 'wallet') {
      walletChecked = !walletChecked;
      offlineChecked = false;
      codChecked = false;
      _paymentMethodIndex = -1;
    }

    notifyListeners();
  }

  String selectedDigitalPaymentMethodName = '';

  void setDigitalPaymentMethodName(int index, String name) {
    _paymentMethodIndex = index;
    selectedDigitalPaymentMethodName = name;
    codChecked = false;
    walletChecked = false;
    offlineChecked = false;
    notifyListeners();
  }

  void digitalOnly(bool value, {bool isUpdate = false}) {
    _onlyDigital = value;
    if (isUpdate) {
      notifyListeners();
    }
  }

  OfflinePaymentModel? offlinePaymentModel;
  Future<ApiResponse> getOfflinePaymentList() async {
    ApiResponse apiResponse = await checkOutRepo.offlinePaymentList();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      offlineMethodSelectedIndex = 0;
      offlinePaymentModel =
          OfflinePaymentModel.fromJson(apiResponse.response?.data);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  List<TextEditingController> inputFieldControllerList = [];
  List<String?> keyList = [];
  int offlineMethodSelectedIndex = -1;
  int offlineMethodSelectedId = 0;
  String offlineMethodSelectedName = '';

  void setOfflinePaymentMethodSelectedIndex(int index, {bool notify = true}) {
    keyList = [];
    inputFieldControllerList = [];
    offlineMethodSelectedIndex = index;
    if (offlinePaymentModel != null &&
        offlinePaymentModel!.offlineMethods != null &&
        offlinePaymentModel!.offlineMethods!.isNotEmpty) {
      offlineMethodSelectedId =
          offlinePaymentModel!.offlineMethods![offlineMethodSelectedIndex].id!;
      offlineMethodSelectedName = offlinePaymentModel!
          .offlineMethods![offlineMethodSelectedIndex].methodName!;
    }

    if (offlinePaymentModel!.offlineMethods != null &&
        offlinePaymentModel!.offlineMethods!.isNotEmpty &&
        offlinePaymentModel!
            .offlineMethods![index].methodInformations!.isNotEmpty) {
      for (int i = 0;
          i <
              offlinePaymentModel!
                  .offlineMethods![index].methodInformations!.length;
          i++) {
        inputFieldControllerList.add(TextEditingController());
        keyList.add(offlinePaymentModel!
            .offlineMethods![index].methodInformations![i].customerInput);
      }
    }
    if (notify) {
      notifyListeners();
    }
  }

  Future<ApiResponse> digitalPayment(
      {String? orderNote,
      String? customerId,
      String? addressId,
      String? billingAddressId,
      String? couponCode,
      String? couponDiscount,
      String? paymentMethod}) async {
    _isLoading = true;

    print('online paymentzz');

    ApiResponse apiResponse = await checkOutRepo.digitalPayment(
        orderNote,
        customerId,
        addressId,
        billingAddressId,
        couponCode,
        couponDiscount,
        paymentMethod);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isLoading = false;
      Navigator.pushReplacement(
          Get.context!,
          MaterialPageRoute(
              builder: (_) => DigitalPaymentScreen(
                  url: apiResponse.response?.data['redirect_link'])));
    } else {
      _isLoading = false;
      showCustomSnackBar(
          '${getTranslated('payment_method_not_properly_configured', Get.context!)}',
          Get.context!);
    }
    notifyListeners();
    return apiResponse;
  }
}
