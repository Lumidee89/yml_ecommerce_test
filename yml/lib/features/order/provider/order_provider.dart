import 'dart:developer';
import 'dart:io';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:yml_ecommerce_test/data/model/api_response.dart';
import 'package:yml_ecommerce_test/features/order/domain/model/order_details_model.dart';
import 'package:yml_ecommerce_test/features/order/domain/model/refund_info_model.dart';
import 'package:yml_ecommerce_test/features/order/domain/model/refund_result_model.dart';
import 'package:yml_ecommerce_test/features/order/domain/model/order_model.dart';
import 'package:yml_ecommerce_test/features/order/domain/repo/order_repo.dart';
import 'package:yml_ecommerce_test/helper/api_checker.dart';
import 'package:yml_ecommerce_test/main.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/features/auth/controllers/auth_controller.dart';
import 'package:yml_ecommerce_test/basewidget/show_custom_snakbar.dart';
import 'package:yml_ecommerce_test/features/cart/views/cart_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utill/app_constants.dart';

class OrderProvider with ChangeNotifier {
  final OrderRepo? orderRepo;
  OrderProvider({required this.orderRepo});

  bool _isLoading = false;
  bool _isRefund = false;
  bool get isRefund => _isRefund;
  bool get isLoading => _isLoading;
  XFile? _imageFile;
  XFile? get imageFile => _imageFile;
  List<XFile?> _refundImage = [];
  List<XFile?> get refundImage => _refundImage;
  List<File> reviewImages = [];
  RefundInfoModel? _refundInfoModel;
  RefundInfoModel? get refundInfoModel => _refundInfoModel;
  RefundResultModel? _refundResultModel;
  RefundResultModel? get refundResultModel => _refundResultModel;

  bool _onlyDigital = true;
  bool get onlyDigital => _onlyDigital;

  void digitalOnly(bool value, {bool isUpdate = false}) {
    _onlyDigital = value;
    if (isUpdate) {
      notifyListeners();
    }
  }

  OrderModel? orderModel;
  OrderModel? deliveredOrderModel;
  Future<void> getOrderList(int offset, String status, {String? type}) async {
    if (offset == 1) {
      orderModel = null;
    }
    ApiResponse apiResponse =
        await orderRepo!.getOrderList(offset, status, type: type);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      if (offset == 1) {
        orderModel = OrderModel.fromJson(apiResponse.response?.data);
        if (type == 'reorder') {
          deliveredOrderModel = OrderModel.fromJson(apiResponse.response?.data);
        }
      } else {
        orderModel!.orders!
            .addAll(OrderModel.fromJson(apiResponse.response?.data).orders!);
        orderModel!.offset =
            OrderModel.fromJson(apiResponse.response?.data).offset;
        orderModel!.totalSize =
            OrderModel.fromJson(apiResponse.response?.data).totalSize;
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  int _orderTypeIndex = 0;
  int get orderTypeIndex => _orderTypeIndex;

  String selectedType = 'ongoing';
  void setIndex(int index, {bool notify = true}) {
    _orderTypeIndex = index;
    if (_orderTypeIndex == 0) {
      selectedType = 'ongoing';
      getOrderList(1, 'ongoing');
    } else if (_orderTypeIndex == 1) {
      selectedType = 'delivered';
      getOrderList(1, 'delivered');
    } else if (_orderTypeIndex == 2) {
      selectedType = 'canceled';
      getOrderList(1, 'canceled');
    }
    if (notify) {
      notifyListeners();
    }
  }

  List<OrderDetailsModel>? _orderDetails;
  List<OrderDetailsModel>? get orderDetails => _orderDetails;

  Future<ApiResponse> getOrderDetails(String orderID) async {
    print('startedq');
    _orderDetails = null;
    ApiResponse apiResponse = await orderRepo!.getOrderDetails(orderID);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _orderDetails = null;
      _orderDetails = [];
      print('startedqq');
      apiResponse.response!.data.forEach(
          (order) => _orderDetails!.add(OrderDetailsModel.fromJson(order)));
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  Orders? orders;
  Future<void> getOrderFromOrderId(String orderID) async {
    ApiResponse apiResponse = await orderRepo!.getOrderFromOrderId(orderID);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      orders = Orders.fromJson(apiResponse.response!.data);
      log("===Delivery MAN==> ${orders?.deliveryMan?.fName}");
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  void stopLoader({bool notify = true}) {
    _isLoading = false;
    if (notify) {
      notifyListeners();
    }
  }

  Orders? trackingModel;
  Future<void> initTrackingInfo(String orderID) async {
    ApiResponse apiResponse = await orderRepo!.getTrackingInfo(orderID);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      trackingModel = Orders.fromJson(apiResponse.response!.data);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  void pickImage(bool isRemove, {bool fromReview = false}) async {
    if (isRemove) {
      _imageFile = null;
      _refundImage = [];
      reviewImages = [];
    } else {
      _imageFile = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 20);
      if (_imageFile != null) {
        if (fromReview) {
          reviewImages.add(File(_imageFile!.path));
        } else {
          _refundImage.add(_imageFile);
        }
      }
    }
    notifyListeners();
  }

  void removeImage(int index, {bool fromReview = false}) {
    if (fromReview) {
      reviewImages.removeAt(index);
    } else {
      _refundImage.removeAt(index);
    }

    notifyListeners();
  }

  Future<http.StreamedResponse> refundRequest(
      BuildContext context,
      int? orderDetailsId,
      double? amount,
      String refundReason,
      String token) async {
    _isLoading = true;
    notifyListeners();
    http.StreamedResponse response = await orderRepo!.refundRequest(
        orderDetailsId, amount, refundReason, refundImage, token);
    if (response.statusCode == 200) {
      getRefundReqInfo(orderDetailsId);
      _imageFile = null;
      _refundImage = [];
      _isLoading = false;
    } else {
      _isLoading = false;
    }
    _imageFile = null;
    _refundImage = [];
    _isLoading = false;
    notifyListeners();
    return response;
  }

  Future<ApiResponse> getRefundReqInfo(int? orderDetailId) async {
    _isRefund = true;
    ApiResponse apiResponse = await orderRepo!.getRefundInfo(orderDetailId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _refundInfoModel = RefundInfoModel.fromJson(apiResponse.response!.data);
      _isRefund = false;
    } else if (apiResponse.response!.statusCode == 202) {
      _isRefund = false;
      showCustomSnackBar(
          '${apiResponse.response!.data['message']}', Get.context!);
    } else {
      _isRefund = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  Future<ApiResponse> getRefundResult(
      BuildContext context, int? orderDetailId) async {
    _isLoading = true;

    ApiResponse apiResponse = await orderRepo!.getRefundResult(orderDetailId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isLoading = false;
      _refundResultModel =
          RefundResultModel.fromJson(apiResponse.response!.data);
    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  Future<ApiResponse> cancelOrder(BuildContext context, int? orderId) async {
    _isLoading = true;
    ApiResponse apiResponse = await orderRepo!.cancelOrder(orderId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isLoading = false;
    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  void downloadFile(String url, String dir) async {
    await FlutterDownloader.enqueue(
      url: url,
      savedDir: dir,
      showNotification: true,
      saveInPublicStorage: true,
      openFileFromNotification: true,
    );
  }

  bool searching = false;
  Future<ApiResponse> trackYourOrder(
      {String? orderId, String? phoneNumber}) async {
    searching = true;
    notifyListeners();
    ApiResponse apiResponse =
        await orderRepo!.trackYourOrder(orderId!, phoneNumber!);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      searching = false;
      _orderDetails = [];
      apiResponse.response!.data.forEach(
          (order) => _orderDetails!.add(OrderDetailsModel.fromJson(order)));
    } else {
      searching = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  Future<ApiResponse> downloadDigitalProduct({int? orderDetailsId}) async {
    ApiResponse apiResponse =
        await orderRepo!.downloadDigitalProduct(orderDetailsId!);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Provider.of<AuthController>(Get.context!, listen: false).resendTime =
          (apiResponse.response!.data["time_count_in_second"]);
    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  Future<ApiResponse> resendOtpForDigitalProduct({int? orderId}) async {
    ApiResponse apiResponse =
        await orderRepo!.resendOtpForDigitalProduct(orderId!);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  Future<ApiResponse> otpVerificationDigitalProduct(
      {required int orderId, required String otp}) async {
    ApiResponse apiResponse =
        await orderRepo!.otpVerificationForDigitalProduct(orderId, otp);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Navigator.of(Get.context!).pop();
      _launchUrl(Uri.parse(
          '${AppConstants.baseUrl}${AppConstants.otpVerificationForDigitalProduct}?order_details_id=$orderId&otp=$otp&guest_id=1&action=download'));
    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  Future<ApiResponse> reorder({String? orderId}) async {
    _isLoading = true;

    ApiResponse apiResponse = await orderRepo!.reorder(orderId!);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      showCustomSnackBar(apiResponse.response?.data['message'], Get.context!,
          isError: false);
      Navigator.push(
          Get.context!, MaterialPageRoute(builder: (_) => const CartScreen()));
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }
}

Future<void> _launchUrl(Uri url) async {
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}
