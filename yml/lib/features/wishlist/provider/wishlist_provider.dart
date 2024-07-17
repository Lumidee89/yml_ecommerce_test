import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:yml_ecommerce_test/data/model/api_response.dart';
import 'package:yml_ecommerce_test/features/product/domain/repo/product_details_repo.dart';
import 'package:yml_ecommerce_test/features/wishlist/domain/model/wishlist_model.dart';
import 'package:yml_ecommerce_test/features/wishlist/domain/repo/wishlist_repo.dart';
import 'package:yml_ecommerce_test/helper/api_checker.dart';
import 'package:yml_ecommerce_test/main.dart';
import 'package:yml_ecommerce_test/basewidget/show_custom_snakbar.dart';

class WishListProvider extends ChangeNotifier {
  final WishListRepo? wishListRepo;
  final ProductDetailsRepo? productDetailsRepo;
  WishListProvider({required this.wishListRepo, required this.productDetailsRepo});

   bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<WishlistModel>? _wishList;
  List<WishlistModel>? get wishList => _wishList;
  List<int> addedIntoWish =[];


  void addWishList(int? productID, ) async {
    _isLoading = true;
    notifyListeners();
    addedIntoWish.add(productID!);
    ApiResponse apiResponse = await wishListRepo!.addWishList(productID);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {

      _isLoading = false;
      Map map = apiResponse.response!.data;
      String? message = map['message'];
      showCustomSnackBar(message, Get.context!, isError: false);

    } else {
      _isLoading = false;
      showCustomSnackBar(apiResponse.error.toString(), Get.context!);
    }
    notifyListeners();
  }

  void removeWishList(int? productID, {int? index, fromWishlist = false}) async {
    _isLoading = true;
    log("===============ppId==>${addedIntoWish.indexOf(productID!)}/${addedIntoWish.toList()}");
    addedIntoWish.removeAt(addedIntoWish.indexOf(productID));
    notifyListeners();
    ApiResponse apiResponse = await wishListRepo!.removeWishList(productID);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      if(fromWishlist){
        getWishList();
      }
      _isLoading = false;
      Map map = apiResponse.response!.data;
      String? message = map['message'];
      showCustomSnackBar(message, Get.context!, isError: false);
    } else {
      _isLoading = false;
      showCustomSnackBar(apiResponse.error.toString(), Get.context!);
    }
    notifyListeners();
  }

  Future<void> getWishList() async {
    List<WishlistModel>?  wishList =[];
    ApiResponse apiResponse = await wishListRepo!.getWishList();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _wishList = [];
      addedIntoWish = [];
      apiResponse.response?.data.forEach((wish)=> _wishList?.add(WishlistModel.fromJson(wish)));
      wishList = _wishList;
      if(wishList!.isNotEmpty){
        for(int i=0; i< wishList.length; i++){
          addedIntoWish.add(wishList[i].productId!);
        }

      }
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }

}
