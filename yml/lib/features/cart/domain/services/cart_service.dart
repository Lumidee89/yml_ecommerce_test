import 'dart:developer';
import 'package:yml_ecommerce_test/features/cart/controllers/cart_controller.dart';
import 'package:yml_ecommerce_test/features/cart/domain/models/cart_model.dart';
import 'package:yml_ecommerce_test/features/splash/provider/splash_provider.dart';
import 'package:yml_ecommerce_test/main.dart';
import 'package:provider/provider.dart';

class CartService{
  double amount = 0.0;
  double shippingAmount = 0.0;
  double discount = 0.0;
  double tax = 0.0;
  int totalQuantity = 0;
  int totalPhysical = 0;
  bool onlyDigital= true;
  List<CartModel> cartList = [];
  List<String?> orderTypeShipping = [];
  List<String?> sellerList = [];
  List<List<String>> productType = [];
  List<CartModel> sellerGroupList = [];
  List<List<CartModel>> cartProductList = [];
  List<List<int>> cartProductIndexList = [];
  double freeDeliveryAmountDiscount = 0;


  static double getOrderAmount( List<CartModel> cartList, {double? discount, String? discountType}) {
    double amount = 0;
    for(int i=0;i<cartList.length;i++){
      amount += (cartList[i].price! - cartList[i].discount!) * cartList[i].quantity!;
    }
    return amount;
  }


  static double getOrderTaxAmount( List<CartModel> cartList, {double? discount, String? discountType}) {
    double tax = 0;
    for(int i=0;i<cartList.length;i++){
      if(cartList[i].taxModel == "exclude"){
        tax += cartList[i].tax! * cartList[i].quantity!;
      }

    }
    return tax;
  }


  static double getOrderDiscountAmount( List<CartModel> cartList, {double? discount, String? discountType}) {
    double discount = 0;
    for(int i=0;i<cartList.length;i++){
      discount += cartList[i].discount! * cartList[i].quantity!;
    }
    return discount;
  }

  static List<String?> getSellerList( List<CartModel> cartList, {double? discount, String? discountType}) {
    List<String?> sellerList = [];
    for(CartModel cart in cartList) {
      if(!sellerList.contains(cart.cartGroupId)) {
        sellerList.add(cart.cartGroupId);
      }
    }
    return sellerList;
  }

  static List<CartModel> getSellerGroupList(List<String?> sellerList, List<CartModel> cartList, {double? discount, String? discountType}) {
    List<CartModel> sellerGroupList = [];
    for(CartModel cart in cartList) {
      if(!sellerList.contains(cart.cartGroupId)) {
        sellerList.add(cart.cartGroupId);
        sellerGroupList.add(cart);
      }
    }
    return sellerGroupList;
  }

  static bool emptyCheck(List<CartModel> sellerGroupList, List<List<CartModel>> cartProductList) {
    bool hasNull = false;
    if(Provider.of<SplashProvider>(Get.context!, listen: false).configModel!.shippingMethod =='sellerwise_shipping'){
      for(int index = 0; index < cartProductList.length; index++) {
        for(CartModel cart in cartProductList[index]) {
          if(cart.productType == 'physical' && sellerGroupList[index].shippingType == 'order_wise'  && Provider.of<CartController>(Get.context!, listen: false).shippingList![index].shippingIndex == -1) {
            hasNull = true;
            break;
          }
        }
      }
    }
    log("====st==> $hasNull");
    return hasNull;
  }

  static bool checkMinimumOrderAmount(List<List<CartModel>> cartProductList, List<CartModel> cartList, double shippingAmount) {
    bool minimum = false;
    double total = 0;
    for(int index = 0; index < cartProductList.length; index++) {
      for(CartModel cart in cartProductList[index]) {
        total += (cart.price! - cart.discount!) * cart.quantity! + getOrderTaxAmount(cartList)+ shippingAmount;
        if(total< cart.minimumOrderAmountInfo!) {
          minimum = true;
        }
      }
    }
    log("====st==> $minimum");
    return minimum;
  }
}