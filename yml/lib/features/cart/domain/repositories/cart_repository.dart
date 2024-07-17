import 'dart:developer';
import 'package:yml_ecommerce_test/data/datasource/remote/dio/dio_client.dart';
import 'package:yml_ecommerce_test/data/datasource/remote/exception/api_error_handler.dart';
import 'package:yml_ecommerce_test/data/model/api_response.dart';
import 'package:yml_ecommerce_test/features/cart/domain/models/cart_model.dart';
import 'package:yml_ecommerce_test/features/product/domain/model/product_model.dart';
import 'package:yml_ecommerce_test/main.dart';
import 'package:yml_ecommerce_test/features/auth/controllers/auth_controller.dart';
import 'package:yml_ecommerce_test/utill/app_constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartRepository{
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  CartRepository({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> getCartListData() async {
    try {
      final response = await dioClient!.get('${AppConstants.getCartDataUri}?guest_id=${Provider.of<AuthController>(Get.context!, listen: false).getGuestToken()}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  Future<ApiResponse> addToCartListData(CartModelBody cart, List<ChoiceOptions> choiceOptions, List<int>? variationIndexes) async {
    Map<String?, dynamic> choice = {};
    for(int index=0; index<choiceOptions.length; index++){
      choice.addAll({choiceOptions[index].name: choiceOptions[index].options![variationIndexes![index]]});
    }
    Map<String?, dynamic> data = {'id': cart.productId,
      'guest_id' : Provider.of<AuthController>(Get.context!, listen: false).getGuestToken(),
      'variant': cart.variation?.type,
      'quantity': cart.quantity};
    data.addAll(choice);
    if(cart.variant!.isNotEmpty) {
      data.addAll({'color': cart.color});
    }

    try {
      final response = await dioClient!.post(
        AppConstants.addToCartUri,
        data: data,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updateQuantity( int? key,int quantity) async {
    try {
      final response = await dioClient!.post(AppConstants.updateCartQuantityUri,
        data: {'_method': 'put',
          'key': key,
          'quantity': quantity,
          'guest_id' : Provider.of<AuthController>(Get.context!, listen: false).getGuestToken(),
        });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> removeFromCart(int? key) async {
    try {
      final response = await dioClient!.post(AppConstants.removeFromCartUri,
          data: {'_method': 'delete',
            'guest_id' : Provider.of<AuthController>(Get.context!, listen: false).getGuestToken(),
            'key': key});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getShippingMethod(int? sellerId, String? type) async {
    try {
      final response = await dioClient!.get('${AppConstants.getShippingMethod}/$sellerId/$type');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponse> addShippingMethod(int? id, String? cartGroupId) async {
    log('===>${{"id":id, "cart_group_id": cartGroupId}}');
    try {
      final response = await dioClient!.post(AppConstants.chooseShippingMethod,
          data: {"id":id, 'guest_id' : Provider.of<AuthController>(Get.context!, listen: false).getGuestToken(),
            "cart_group_id": cartGroupId});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getChosenShippingMethod() async {
    try {
      final response =await dioClient!.get('${AppConstants.chosenShippingMethod}?guest_id=${Provider.of<AuthController>(Get.context!, listen: false).getGuestToken()}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponse> getSelectedShippingType(int sellerId, String sellerType) async {
    try {
      final response = await dioClient!.get('${AppConstants.getSelectedShippingTypeUri}?seller_id=$sellerId&seller_is=$sellerType');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
