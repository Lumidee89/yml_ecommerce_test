import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/features/order/provider/order_provider.dart';
import 'package:yml_ecommerce_test/utill/color_resources.dart';
import 'package:yml_ecommerce_test/utill/custom_themes.dart';
import 'package:provider/provider.dart';

class OrderTypeButton extends StatelessWidget {
  final String? text;
  final int index;


  const OrderTypeButton({super.key, required this.text, required this.index});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: () => Provider.of<OrderProvider>(context, listen: false).setIndex(index),
        style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
        child: Container(
          height: 35,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Provider.of<OrderProvider>(context, listen: false).orderTypeIndex == index ? ColorResources.getPrimary(context) : Theme.of(context).primaryColor.withOpacity(0.07),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text!,
                  style: titilliumBold.copyWith(color: Provider.of<OrderProvider>(context, listen: false).orderTypeIndex == index
                      ? Theme.of(context).highlightColor : ColorResources.getReviewRattingColor(context))),
              const SizedBox(width: 5),

              // Container(
              //   height: 20,
              //   alignment: Alignment.center,
              //   padding: const EdgeInsets.only(left: 5, right: 5, top: 1, bottom: 1),
              //   decoration: BoxDecoration(
              //     color: Provider.of<OrderProvider>(context, listen: false).orderTypeIndex == index ? Theme.of(context).highlightColor.withOpacity(0.15): Theme.of(context).cardColor.withOpacity(0.9),
              //     borderRadius: BorderRadius.circular(25),
              //   ),
              //   child: Text('${orderList!.length}', style: titilliumBold.copyWith(color: Provider.of<OrderProvider>(context, listen: false).orderTypeIndex == index
              //       ? Theme.of(context).highlightColor : ColorResources.getReviewRattingColor(context))),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}