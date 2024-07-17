import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/data/model/api_response.dart';
import 'package:yml_ecommerce_test/features/brand/domain/models/brand_model.dart';
import 'package:yml_ecommerce_test/features/brand/domain/repositories/brand_repository.dart';
import 'package:yml_ecommerce_test/helper/api_checker.dart';

class BrandController extends ChangeNotifier {
  final BrandRepository? brandRepo;

  BrandController({required this.brandRepo});

  List<BrandModel>? _brandList;

  List<BrandModel>? get brandList => _brandList;

  final List<BrandModel> _originalBrandList = [];

  Future<void> getBrandList(bool reload) async {
    if (_brandList == null || reload) {
      ApiResponse apiResponse = await brandRepo!.getBrandList();
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _originalBrandList.clear();
        apiResponse.response!.data.forEach((brand) => _originalBrandList.add(BrandModel.fromJson(brand)));
        _brandList = [];
        apiResponse.response!.data.forEach((brand) => _brandList?.add(BrandModel.fromJson(brand)));
      } else {
        ApiChecker.checkApi( apiResponse);
      }
      notifyListeners();
    }
  }

  Future<void> getSellerWiseBrandList(int sellerId) async {

      ApiResponse apiResponse = await brandRepo!.getSellerWiseBrandList(sellerId);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _originalBrandList.clear();
        apiResponse.response!.data.forEach((brand) => _originalBrandList.add(BrandModel.fromJson(brand)));
        _brandList = [];
        apiResponse.response!.data.forEach((brand) => _brandList?.add(BrandModel.fromJson(brand)));
      } else {
        ApiChecker.checkApi( apiResponse);
      }
      notifyListeners();

  }


  void checkedToggleBrand(int index){
    _brandList![index].checked = !_brandList![index].checked!;
    notifyListeners();
  }

  bool isTopBrand = true;
  bool isAZ = false;
  bool isZA = false;

  void sortBrandLis(int value) {
    if (value == 0) {
      _brandList = [];
      _brandList?.addAll(_originalBrandList);
      isTopBrand = true;
      isAZ = false;
      isZA = false;
    } else if (value == 1) {
      _brandList = [];
      _brandList?.addAll(_originalBrandList);
      _brandList?.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      isTopBrand = false;
      isAZ = true;
      isZA = false;
    } else if (value == 2) {
      _brandList = [];
      _brandList?.addAll(_originalBrandList);
      _brandList?.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      Iterable iterable = _brandList!.reversed;
      _brandList = iterable.toList() as List<BrandModel>;
      isTopBrand = false;
      isAZ = false;
      isZA = true;
    }

    notifyListeners();
  }
}
