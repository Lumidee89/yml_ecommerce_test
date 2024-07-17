import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/data/model/api_response.dart';
import 'package:yml_ecommerce_test/features/deal/domain/repo/featured_deal_repo.dart';
import 'package:yml_ecommerce_test/features/product/domain/model/product_model.dart';

import 'package:yml_ecommerce_test/helper/api_checker.dart';

class FeaturedDealProvider extends ChangeNotifier {
  final FeaturedDealRepo? featuredDealRepo;

  FeaturedDealProvider({required this.featuredDealRepo});

  int? _featuredDealSelectedIndex;
  List<Product>? _featuredDealProductList;
  List<Product>? get featuredDealProductList =>_featuredDealProductList;
  int? get featuredDealSelectedIndex => _featuredDealSelectedIndex;


  Future<void> getFeaturedDealList(bool reload) async {
    _featuredDealProductList =[];
      ApiResponse apiResponse = await featuredDealRepo!.getFeaturedDeal();
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200 && apiResponse.response!.data.toString() != '{}') {
        _featuredDealProductList =[];
        apiResponse.response!.data.forEach((fDeal) => _featuredDealProductList?.add(Product.fromJson(fDeal)));
        _featuredDealSelectedIndex = 0;
      } else {
        ApiChecker.checkApi( apiResponse);
      }
      notifyListeners();

  }

  void changeSelectedIndex(int selectedIndex) {
    _featuredDealSelectedIndex = selectedIndex;
    notifyListeners();
  }
}
