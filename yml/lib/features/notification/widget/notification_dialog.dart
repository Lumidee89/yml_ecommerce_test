import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/features/notification/domain/model/notification_model.dart';
import 'package:yml_ecommerce_test/features/splash/provider/splash_provider.dart';
import 'package:yml_ecommerce_test/utill/custom_themes.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/basewidget/custom_image.dart';
import 'package:provider/provider.dart';

class NotificationDialog extends StatelessWidget {
  final NotificationItem notificationModel;
  const NotificationDialog({super.key, required this.notificationModel});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(mainAxisSize: MainAxisSize.min, children: [

        const SizedBox(height: Dimensions.paddingSizeDefault,),

        InkWell(onTap: ()=>Navigator.of(context).pop(),
          child: Container(
            width: 40,height: 5,decoration: BoxDecoration(
              color: Theme.of(context).hintColor.withOpacity(.5),
              borderRadius: BorderRadius.circular(20)
          ),),
        ),
        const SizedBox(height: 20,),
          notificationModel.image != "null"?
          Container(height: MediaQuery.of(context).size.width-130, width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            decoration: BoxDecoration( color: Theme.of(context).primaryColor.withOpacity(0.20)),
            child: CustomImage(image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.notificationImageUrl}/${notificationModel.image}',
              height: MediaQuery.of(context).size.width-130, width: MediaQuery.of(context).size.width,)
          ):const SizedBox(),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Text(notificationModel.title!, textAlign: TextAlign.center,
              style: titilliumSemiBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge))),

          Padding(padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Text(notificationModel.description!, textAlign: TextAlign.center, style: titilliumRegular)),

        const SizedBox(height: Dimensions.paddingSizeSmall,),

        ],
      ),
    );
  }
}
