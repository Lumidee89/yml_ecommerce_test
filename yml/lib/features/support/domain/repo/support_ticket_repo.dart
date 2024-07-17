import 'package:yml_ecommerce_test/data/datasource/remote/dio/dio_client.dart';
import 'package:yml_ecommerce_test/data/datasource/remote/exception/api_error_handler.dart';
import 'package:yml_ecommerce_test/features/support/domain/model/support_ticket_body.dart';
import 'package:yml_ecommerce_test/data/model/api_response.dart';
import 'package:yml_ecommerce_test/utill/app_constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yml_ecommerce_test/main.dart';
import 'package:yml_ecommerce_test/features/auth/controllers/auth_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';




class SupportTicketRepo {
  final DioClient? dioClient;
  SupportTicketRepo({required this.dioClient});


  Future<http.StreamedResponse> createNewSupportTicket(SupportTicketBody supportTicketModel, List<XFile?> file) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.supportTicketUri}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer ${Provider.of<AuthController>(Get.context!, listen: false).getUserToken()}'});
    for(int i=0; i<file.length;i++){
      Uint8List list = await file[i]!.readAsBytes();
      var part = http.MultipartFile('image[]', file[i]!.readAsBytes().asStream(), list.length, filename: basename(file[i]!.path), contentType: MediaType('image', 'jpg'));
      request.files.add(part);
    }
    Map<String, String> fields = {};
    request.fields.addAll(<String, String>{
      'type': supportTicketModel.type??'',
      'subject': supportTicketModel.subject??'',
      'description': supportTicketModel.description??'',
      'priority': supportTicketModel.priority??'',
    });
    request.fields.addAll(fields);
    http.StreamedResponse response = await request.send();
    return response;
  }

  Future<ApiResponse> getSupportTicketList() async {
    try {
      final response = await dioClient!.get(AppConstants.getSupportTicketUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSupportReplyList(String ticketID) async {
    try {
      final response = await dioClient!.get('${AppConstants.supportTicketConversationUri}$ticketID');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<http.StreamedResponse> sendReply(String ticketID, String message, List<XFile?> file) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.supportTicketReplyUri}$ticketID'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer ${Provider.of<AuthController>(Get.context!, listen: false).getUserToken()}'});
    for(int i=0; i<file.length;i++){
      Uint8List list = await file[i]!.readAsBytes();
      var part = http.MultipartFile('image[]', file[i]!.readAsBytes().asStream(), list.length, filename: basename(file[i]!.path), contentType: MediaType('image', 'jpg'));
      request.files.add(part);
    }
    Map<String, String> fields = {};
    request.fields.addAll(<String, String>{
      'message': message,
    });
    request.fields.addAll(fields);
    http.StreamedResponse response = await request.send();
    return response;
  }
  Future<ApiResponse> closeSupportTicket(String ticketID) async {
    try {
      final response = await dioClient!.get('${AppConstants.closeSupportTicketUri}$ticketID');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}