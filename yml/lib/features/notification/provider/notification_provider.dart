import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/data/model/api_response.dart';
import 'package:yml_ecommerce_test/features/notification/domain/model/notification_model.dart';
import 'package:yml_ecommerce_test/features/notification/domain/repo/notification_repo.dart';
import 'package:yml_ecommerce_test/helper/api_checker.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationRepo? notificationRepo;

  NotificationProvider({required this.notificationRepo});

  NotificationItemModel? notificationModel;


  Future<void> getNotificationList(int offset) async {
    ApiResponse apiResponse = await notificationRepo!.getNotificationList(offset);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      if(offset == 1){
        notificationModel = NotificationItemModel.fromJson(apiResponse.response?.data);
      }else{
        notificationModel?.notification?.addAll(NotificationItemModel.fromJson(apiResponse.response?.data).notification!);
        notificationModel?.offset = NotificationItemModel.fromJson(apiResponse.response?.data).offset!;
        notificationModel?.totalSize = NotificationItemModel.fromJson(apiResponse.response?.data).totalSize!;
      }

    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }
  Future<void> seenNotification(int id) async {
    ApiResponse apiResponse = await notificationRepo!.seenNotification(id);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      getNotificationList(1);
    }
    notifyListeners();
  }
}
