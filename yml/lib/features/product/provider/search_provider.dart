import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/data/model/api_response.dart';
import 'package:yml_ecommerce_test/features/product/domain/model/product_model.dart';
import 'package:yml_ecommerce_test/features/compare/provider/compare_provider.dart';
import 'package:yml_ecommerce_test/features/product/domain/repo/search_repo.dart';
import 'package:yml_ecommerce_test/helper/api_checker.dart';
import 'package:yml_ecommerce_test/main.dart';
import 'package:yml_ecommerce_test/utill/app_constants.dart';
import 'package:yml_ecommerce_test/features/search/model/suggestion_product_model.dart';
import 'package:provider/provider.dart';

class SearchProvider with ChangeNotifier {
  final SearchRepo? searchRepo;
  SearchProvider({required this.searchRepo});

  int _filterIndex = 0;
  List<String> _historyList = [];

  int get filterIndex => _filterIndex;
  List<String> get historyList => _historyList;

  double minPriceForFilter = AppConstants.minFilter;
  double maxPriceForFilter = AppConstants.maxFilter;

  void setMinMaxPriceForFilter(RangeValues currentRangeValues){
    minPriceForFilter = currentRangeValues.start;
    maxPriceForFilter = currentRangeValues.end;
    notifyListeners();
  }

  String sortText = 'low-high';
  void setFilterIndex(int index) {
    _filterIndex = index;
    if(index == 0){
      sortText = 'latest';
    }else if(index == 1){
      sortText = 'a-z';
    }else if(index == 2){
      sortText = 'z-a';
    }
    else if(index == 3){
      sortText = 'low-high';
    }else if(index ==4){
      sortText = 'high-low';
    }


    notifyListeners();
  }



  bool _isClear = true;


  bool get isClear => _isClear;




  void cleanSearchProduct() {
    searchedProduct = null;
    _isClear = true;


  }



  ProductModel? searchedProduct;
  Future searchProduct(
      {required String query,
      String? categoryIds,
        String? brandIds,
      String? sort,
      String? priceMin,
      String? priceMax,
      required int offset}) async {

    searchController.text = query;
    ApiResponse apiResponse = await searchRepo!.getSearchProductList(query, categoryIds, brandIds, sort, priceMin, priceMax, offset);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      if(offset == 1){
        searchedProduct = null;
        if(ProductModel.fromJson(apiResponse.response!.data).products != null){
          searchedProduct = ProductModel.fromJson(apiResponse.response!.data);
        }
      }else{
        if(ProductModel.fromJson(apiResponse.response!.data).products != null){
          searchedProduct?.products?.addAll(ProductModel.fromJson(apiResponse.response!.data).products!) ;
          searchedProduct?.offset = (ProductModel.fromJson(apiResponse.response!.data).offset) ;
          searchedProduct?.totalSize = (ProductModel.fromJson(apiResponse.response!.data).totalSize) ;
        }
      }
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }

  TextEditingController searchController = TextEditingController();

  SuggestionModel? suggestionModel;
  List<String> nameList = [];
  List<int> idList = [];
  Future<void> getSuggestionProductName(String name) async {

    ApiResponse apiResponse = await searchRepo!.getSearchProductName(name);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      nameList = [];
      idList = [];
      suggestionModel = SuggestionModel.fromJson(apiResponse.response?.data);
      for(int i=0; i< suggestionModel!.products!.length; i++){
        nameList.add(suggestionModel!.products![i].name!);
        idList.add(suggestionModel!.products![i].id!);
      }
    }
    notifyListeners();
  }

  void initHistoryList() {
    _historyList = [];
    _historyList.addAll(searchRepo!.getSearchAddress());

  }

  int selectedSearchedProductId = 0;
  void setSelectedProductId(int index, int? compareId){

    if(suggestionModel!.products!.isNotEmpty){
      selectedSearchedProductId = suggestionModel!.products![index].id!;
    }

    if(compareId != null){
      Provider.of<CompareProvider>(Get.context!, listen: false).replaceCompareList(compareId ,selectedSearchedProductId);
    }else{
      Provider.of<CompareProvider>(Get.context!, listen: false).addCompareList(selectedSearchedProductId);
    }

    notifyListeners();
  }

  void saveSearchAddress(String searchAddress) async {
    searchRepo!.saveSearchAddress(searchAddress);
    if (!_historyList.contains(searchAddress)) {
      _historyList.add(searchAddress);
    }
    notifyListeners();
  }

  void clearSearchAddress() async {
    searchRepo!.clearSearchAddress();
    _historyList = [];
    notifyListeners();
  }

  void clearSearch(int index) async {
    searchRepo!.clearSearchAddress();
    _historyList = [];
    notifyListeners();
  }


}
