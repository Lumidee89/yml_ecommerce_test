import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:yml_ecommerce_test/data/datasource/remote/dio/dio_client.dart';
import 'package:yml_ecommerce_test/data/datasource/remote/exception/api_error_handler.dart';
import 'package:yml_ecommerce_test/data/model/api_response.dart';
import 'package:yml_ecommerce_test/main.dart';
import 'package:yml_ecommerce_test/features/auth/controllers/auth_controller.dart';
import 'package:yml_ecommerce_test/utill/app_constants.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class CheckOutRepo {
  final DioClient? dioClient;
  CheckOutRepo({required this.dioClient});

  Future<ApiResponse> getShippingList() async {
    try {
      final response = await dioClient!.get(AppConstants.shippingUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getShippingMethod(int sellerId) async {
    try {
      final response = sellerId == 1
          ? await dioClient!
              .get('${AppConstants.getShippingMethod}/$sellerId/admin')
          : await dioClient!
              .get('${AppConstants.getShippingMethod}/$sellerId/seller');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> placeOrder(
      String? addressID,
      String? couponCode,
      String? couponDiscountAmount,
      String? billingAddressId,
      String? orderNote) async {
    try {
      final response = await dioClient!.get(
          '${AppConstants.orderPlaceUri}?address_id=$addressID&coupon_code=$couponCode&coupon_discount=$couponDiscountAmount&billing_address_id=$billingAddressId&order_note=$orderNote&guest_id=${Provider.of<AuthController>(Get.context!, listen: false).getGuestToken()}&is_guest=${Provider.of<AuthController>(Get.context!, listen: false).isLoggedIn() ? 0 : 1}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> offlinePaymentPlaceOrder(
      String? addressID,
      String? couponCode,
      String? couponDiscountAmount,
      String? billingAddressId,
      String? orderNote,
      List<String?> typeKey,
      List<String> typeValue,
      int? id,
      String name,
      String? paymentNote) async {
    try {
      Map<String?, String> fields = {};
      Map<String?, String> info = {};

      for (var i = 0; i < typeKey.length; i++) {
        info.addAll(<String?, String>{typeKey[i]: typeValue[i]});
      }

      fields.addAll(<String, String>{
        "method_informations": base64.encode(utf8.encode(jsonEncode(info))),
        'method_name': name,
        'method_id': id.toString(),
        'payment_note': paymentNote ?? '',
        'address_id': addressID ?? '',
        'coupon_code': couponCode ?? "",
        'coupon_discount': couponDiscountAmount ?? '',
        'billing_address_id': billingAddressId ?? '',
        'order_note': orderNote ?? '',
        'guest_id': Provider.of<AuthController>(Get.context!, listen: false)
                .getGuestToken() ??
            '',
        'is_guest': Provider.of<AuthController>(Get.context!, listen: false)
                .isLoggedIn()
            ? '0'
            : '1'
      });

      if (kDebugMode) {
        print('--here is type key =$id/$name');
      }
      Response response =
          await dioClient!.post(AppConstants.offlinePayment, data: fields);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> walletPaymentPlaceOrder(
      String? addressID,
      String? couponCode,
      String? couponDiscountAmount,
      String? billingAddressId,
      String? orderNote) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.walletPayment}?address_id=$addressID&coupon_code=$couponCode&coupon_discount=$couponDiscountAmount&billing_address_id=$billingAddressId&order_note=$orderNote&guest_id=${Provider.of<AuthController>(Get.context!, listen: false).getGuestToken()}&is_guest=${Provider.of<AuthController>(Get.context!, listen: false).isLoggedIn() ? 0 : 1}',
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> offlinePaymentList() async {
    try {
      final response = await dioClient!.get(
          '${AppConstants.offlinePaymentList}?guest_id=${Provider.of<AuthController>(Get.context!, listen: false).getGuestToken()}&is_guest=${!Provider.of<AuthController>(Get.context!, listen: false).isLoggedIn()}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> digitalPayment(
    String? orderNote,
    String? customerId,
    String? addressId,
    String? billingAddressId,
    String? couponCode,
    String? couponDiscount,
    String? paymentMethod,
  ) async {
    try {
      final response =
          await dioClient!.post(AppConstants.digitalPayment, data: {
        "order_note": orderNote,
        "customer_id": customerId,
        "address_id": addressId,
        "billing_address_id": billingAddressId,
        "coupon_code": couponCode,
        "coupon_discount": couponDiscount,
        "payment_platform": "app",
        "payment_method": paymentMethod,
        "callback": null,
        "payment_request_from": "app",
        'guest_id': Provider.of<AuthController>(Get.context!, listen: false)
            .getGuestToken(),
        'is_guest': 0,
      });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
