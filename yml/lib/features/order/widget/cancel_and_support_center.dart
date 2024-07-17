import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/features/order/domain/model/order_model.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/features/auth/controllers/auth_controller.dart';
import 'package:yml_ecommerce_test/features/order/provider/order_provider.dart';
import 'package:yml_ecommerce_test/features/profile/provider/profile_provider.dart';
import 'package:yml_ecommerce_test/utill/color_resources.dart';
import 'package:yml_ecommerce_test/utill/custom_themes.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/basewidget/custom_button.dart';
import 'package:yml_ecommerce_test/features/order/widget/cancel_order_dialog.dart';
import 'package:yml_ecommerce_test/features/support/view/support_ticket_screen.dart';
import 'package:yml_ecommerce_test/features/tracking/view/tracking_result_screen.dart';
import 'package:provider/provider.dart';

class CancelAndSupport extends StatelessWidget {
  final Orders? orderModel;
  final bool fromNotification;
  const CancelAndSupport({super.key, this.orderModel, this.fromNotification = false});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportTicketScreen())),
            child: Text.rich(TextSpan(children: [
              TextSpan(text: getTranslated('if_you_cannot_contact_with_seller_or_facing_any_trouble_then_contact', context),
                style: titilliumRegular.copyWith(color: ColorResources.hintTextColor, fontSize: Dimensions.fontSizeSmall),),
              TextSpan(text: ' ${getTranslated('SUPPORT_CENTER', context)}',
                style: titilliumSemiBold.copyWith(color: ColorResources.getPrimary(context)))]))),
          const SizedBox(height: Dimensions.homePagePadding),


          (orderModel != null &&(orderModel?.paymentMethod == 'cash_on_delivery') && (orderModel!.customerId! == int.parse(Provider.of<ProfileProvider>(context, listen: false).userID)) &&
              (orderModel!.orderStatus == 'pending') && (orderModel!.orderType != "POS")) ?
          CustomButton(textColor: Theme.of(context).colorScheme.error,
              backgroundColor: Theme.of(context).colorScheme.error.withOpacity(0.1),
              buttonText: getTranslated('cancel_order', context),
              onTap: () {
            showDialog(context: context, builder: (context) => Dialog(
                  backgroundColor: Colors.transparent,
                  child: CancelOrderDialog(orderId: orderModel!.id)));}) :



          (orderModel != null && Provider.of<AuthController>(context, listen: false).isLoggedIn() && orderModel!.customerId! == int.parse(Provider.of<ProfileProvider>(context, listen: false).userID) && orderModel!.orderStatus == 'delivered' && orderModel!.orderType != "POS") ?
          CustomButton(textColor: ColorResources.white,
              backgroundColor: Theme.of(context).primaryColor,
              buttonText: getTranslated('re_order', context),
              onTap: () => Provider.of<OrderProvider>(context, listen: false).reorder(orderId: orderModel?.id.toString())):

          (Provider.of<AuthController>(context, listen: false).isLoggedIn() && orderModel!.customerId! == int.parse(Provider.of<ProfileProvider>(context, listen: false).userID) && orderModel!.orderType != "POS" && (orderModel!.orderStatus != 'canceled' &&  orderModel!.orderStatus != 'returned'  && orderModel!.orderStatus != 'fail_to_delivered' ) )?
          CustomButton(buttonText: getTranslated('TRACK_ORDER', context),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => TrackingResultScreen(orderID: orderModel!.id.toString()))),): const SizedBox(),

          const SizedBox(width: Dimensions.paddingSizeSmall),


        ],
      ),
    );
  }
}
