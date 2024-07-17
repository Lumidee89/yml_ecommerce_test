import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/data/model/api_response.dart';
import 'package:yml_ecommerce_test/features/category/domain/model/category_model.dart';
import 'package:yml_ecommerce_test/features/category/domain/repo/category_repo.dart';
import 'package:yml_ecommerce_test/helper/api_checker.dart';
import 'package:yml_ecommerce_test/main.dart';
import 'package:yml_ecommerce_test/features/brand/controllers/brand_controller.dart';
import 'package:yml_ecommerce_test/features/product/provider/product_provider.dart';
import 'package:provider/provider.dart';

class CategoryController extends ChangeNotifier {
  final CategoryRepository? categoryRepo;

  CategoryController({required this.categoryRepo});


   List<CategoryModel>? _categoryList;
  int? _categorySelectedIndex;

  List<CategoryModel>? get categoryList => _categoryList;
  int? get categorySelectedIndex => _categorySelectedIndex;

  Future<void> getCategoryList(bool reload) async {
    if (_categoryList == null || reload) {
      _categoryList = [];
      ApiResponse apiResponse = await categoryRepo!.getCategoryList();
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _categoryList = [];
        apiResponse.response!.data.forEach((category) => _categoryList?.add(CategoryModel.fromJson(category)));
        _categorySelectedIndex = 0;
      } else {
        ApiChecker.checkApi( apiResponse);
      }
      notifyListeners();
    }
  }

  Future<void> getSellerWiseCategoryList(int sellerId) async {
    _categoryList = [];
      ApiResponse apiResponse = await categoryRepo!.getSellerWiseCategoryList(sellerId);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _categoryList = [];
        apiResponse.response!.data.forEach((category) => _categoryList?.add(CategoryModel.fromJson(category)));
        _categorySelectedIndex = 0;
      } else {
        ApiChecker.checkApi( apiResponse);
      }
      notifyListeners();

  }

  List<int> selectedCategoryIds = [];
  void checkedToggleCategory(int index){
    _categoryList![index].isSelected = !_categoryList![index].isSelected!;
    notifyListeners();
  }

  void checkedToggleSubCategory(int index, int subCategoryIndex){
    _categoryList![index].subCategories![subCategoryIndex].isSelected = !_categoryList![index].subCategories![subCategoryIndex].isSelected!;
    notifyListeners();
  }

  void resetChecked(int? id, bool fromShop){
    if(fromShop){
      getSellerWiseCategoryList(id!);
      Provider.of<BrandController>(Get.context!, listen: false).getSellerWiseBrandList(id);
      Provider.of<ProductProvider>(Get.context!, listen: false).getSellerProductList(id.toString(), 1, Get.context!);
    }else{
      getCategoryList(true);
      Provider.of<BrandController>(Get.context!, listen: false).getBrandList(true);
    }


  }

  void changeSelectedIndex(int selectedIndex) {
    _categorySelectedIndex = selectedIndex;
    notifyListeners();
  }
}
