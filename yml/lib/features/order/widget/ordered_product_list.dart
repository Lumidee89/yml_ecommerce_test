import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/features/order/provider/order_provider.dart';
import 'package:yml_ecommerce_test/basewidget/show_custom_snakbar.dart';
import 'package:yml_ecommerce_test/features/order/widget/order_details_widget.dart';

class OrderProductList extends StatelessWidget {
  final OrderProvider? order;
  final String? orderType;
  final bool fromTrack;
  final int? isGuest;
  const OrderProductList({super.key, this.order, this.orderType,  this.fromTrack = false, this.isGuest});

  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(0),
      itemCount:
      order!.orderDetails!.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) => OrderDetailsWidget(orderDetailsModel: order!.orderDetails![i],
          isGuest: isGuest,
          fromTrack: fromTrack,
          callback: () {showCustomSnackBar('${getTranslated('review_submitted_successfully', context)}', context, isError: false);},
          orderType: orderType!, paymentStatus: order!.orders!.paymentStatus!),
    );
  }
}
