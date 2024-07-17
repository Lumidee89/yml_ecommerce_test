import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/data/datasource/remote/dio/dio_client.dart';
import 'package:yml_ecommerce_test/data/datasource/remote/exception/api_error_handler.dart';
import 'package:yml_ecommerce_test/data/model/api_response.dart';
import 'package:yml_ecommerce_test/features/onboarding/domain/model/onboarding_model.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/utill/app_constants.dart';

class OnBoardingRepo{
  final DioClient? dioClient;
  OnBoardingRepo({required this.dioClient});

  Future<ApiResponse> getOnBoardingList(BuildContext context) async {
    try {
      List<OnboardingModel> onBoardingList = [
        OnboardingModel(
          'assets/images/onboarding_image_one.png',
          '${getTranslated('on_boarding_title_one', context)} ${AppConstants.appName}',
          getTranslated('on_boarding_description_one', context),
        ),
        OnboardingModel(
          'assets/images/onboarding_image_two.png',
          getTranslated('on_boarding_title_two', context),
          getTranslated('on_boarding_description_two', context),
        ),
        OnboardingModel(
          'assets/images/onboarding_image_three.png',
          getTranslated('on_boarding_title_three', context),
          getTranslated('on_boarding_description_three', context),
        ),
      ];

      Response response = Response(requestOptions: RequestOptions(path: ''), data: onBoardingList,statusCode: 200);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}