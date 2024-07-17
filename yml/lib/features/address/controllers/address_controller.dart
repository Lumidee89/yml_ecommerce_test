import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/basewidget/show_custom_snakbar.dart';
import 'package:yml_ecommerce_test/features/address/domain/model/address_model.dart';
import 'package:yml_ecommerce_test/data/model/api_response.dart';
import 'package:yml_ecommerce_test/data/model/error_response.dart';
import 'package:yml_ecommerce_test/data/model/response_model.dart';
import 'package:yml_ecommerce_test/features/address/domain/model/restricted_zip_model.dart';
import 'package:yml_ecommerce_test/features/address/domain/repo/address_repository.dart';
import 'package:yml_ecommerce_test/helper/api_checker.dart';
import 'package:yml_ecommerce_test/main.dart';

class AddressController with ChangeNotifier {
  final AddressRepository? addressRepo;

  AddressController({this.addressRepo});

  List<String> _restrictedCountryList = [];
  List<String> get restrictedCountryList => _restrictedCountryList;
  List<RestrictedZipModel> _restrictedZipList = [];
  List<RestrictedZipModel> get restrictedZipList => _restrictedZipList;
  final List<String> _zipNameList = [];
  List<String> get zipNameList => _zipNameList;
  final TextEditingController _searchZipController = TextEditingController();
  TextEditingController get searchZipController => _searchZipController;
  final TextEditingController _searchCountryController =
      TextEditingController();
  TextEditingController get searchCountryController => _searchCountryController;

  final bool _isAvaibleLocation = false;
  bool get isAvaibleLocation => _isAvaibleLocation;
  List<AddressModel> _addressList = [];
  List<AddressModel>? get addressList => _addressList;

  Future<ResponseModel?> getRestrictedDeliveryCountryList(
      BuildContext context) async {
    ResponseModel? responseModel;
    ApiResponse apiResponse =
        await addressRepo!.getDeliveryRestrictedCountryList();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _restrictedCountryList = [];
      apiResponse.response!.data
          .forEach((address) => _restrictedCountryList.add(address));
      responseModel = ResponseModel('successful', true);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel?> getRestrictedDeliveryZipList(
      BuildContext context) async {
    ResponseModel? responseModel;
    ApiResponse apiResponse = await addressRepo!.getDeliveryRestrictedZipList();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _restrictedZipList = [];
      apiResponse.response!.data.forEach((address) =>
          _restrictedZipList.add(RestrictedZipModel.fromJson(address)));
      responseModel = ResponseModel('successful', true);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return responseModel;
  }

  Future<void> getDeliveryRestrictedZipBySearch(
      BuildContext context, String searchName) async {
    _restrictedZipList = [];
    ApiResponse response =
        await addressRepo!.getDeliveryRestrictedZipBySearch(searchName);
    if (response.response!.statusCode == 200) {
      _restrictedZipList = [];
      response.response!.data.forEach((address) {
        _restrictedZipList.add(RestrictedZipModel.fromJson(address));
      });
    } else {
      ApiChecker.checkApi(response);
    }
    notifyListeners();
  }

  Future<void> getDeliveryRestrictedCountryBySearch(
      BuildContext context, String searchName) async {
    _restrictedCountryList = [];
    ApiResponse response =
        await addressRepo!.getDeliveryRestrictedCountryBySearch(searchName);
    if (response.response!.statusCode == 200) {
      _restrictedCountryList = [];
      response.response!.data
          .forEach((address) => _restrictedCountryList.add(address));
    } else {
      if (context.mounted) {}
      ApiChecker.checkApi(response);
    }
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<AddressModel> _billingAddressList = [];
  List<AddressModel> _shippingAddressList = [];
  List<AddressModel> get billingAddressList => _billingAddressList;
  List<AddressModel> get shippingAddressList => _shippingAddressList;

  Future<void> initAddressList({bool fromRemove = false}) async {
    print('started');
    if (!fromRemove) {
      _isLoading = true;
    }
    ApiResponse apiResponse = await addressRepo!.getAllAddress();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _addressList = [];
      _billingAddressList = [];
      _shippingAddressList = [];
      _isLoading = false;
      apiResponse.response!.data.forEach((address) {
        print('success');
        AddressModel addressModel = AddressModel.fromJson(address);
        if (addressModel.isBilling == 0) {
          _billingAddressList.add(addressModel);
        } else if (addressModel.isBilling == 1) {
          _addressList.add(addressModel);
        }
        _addressList.add(addressModel);
        _shippingAddressList.add(addressModel);
      });
    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  void removeAddressById(int? id, int index, BuildContext context) async {
    ApiResponse apiResponse = await addressRepo!.removeAddressByID(id);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      showCustomSnackBar(apiResponse.response!.data['message'], Get.context!,
          isError: false);
      initAddressList(fromRemove: true);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<ResponseModel> addAddress(
      AddressModel addressModel, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await addressRepo!.addAddress(addressModel);
    _isLoading = false;
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      if (context.mounted) {}
      String? message = map["message"];
      responseModel = ResponseModel(message, true);
      initAddressList();
    } else {
      String? errorMessage = apiResponse.error.toString();
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
      responseModel = ResponseModel(errorMessage, false);
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> updateAddress(BuildContext context,
      {required AddressModel addressModel, int? addressId}) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse =
        await addressRepo!.updateAddress(addressModel, addressId);
    _isLoading = false;
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      if (context.mounted) {}
      String? message = map["message"];
      responseModel = ResponseModel(message, true);
    } else {
      String? errorMessage = apiResponse.error.toString();
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
      responseModel = ResponseModel(errorMessage, false);
    }
    notifyListeners();
    return responseModel;
  }

  void setZip(String zip) {
    _searchZipController.text = zip;
    notifyListeners();
  }

  void setCountry(String country) {
    _searchCountryController.text = country;
    notifyListeners();
  }

  List<LabelAsModel> addressTypeList = [];
  int _selectAddressIndex = 0;

  int get selectAddressIndex => _selectAddressIndex;

  updateAddressIndex(int index, bool notify) {
    _selectAddressIndex = index;
    if (notify) {
      notifyListeners();
    }
  }

  initializeAllAddressType({BuildContext? context}) {
    if (addressTypeList.isEmpty) {
      addressTypeList = [];
      addressTypeList = addressRepo!.getAllAddressType(context: context);
    }
  }
}
