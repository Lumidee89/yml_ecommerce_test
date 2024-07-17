import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/utill/custom_themes.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';

class AmountWidget extends StatelessWidget {
  final String? title;
  final String amount;

  const AmountWidget({super.key, required this.title, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title!, style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.5))),
        Text(amount, style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
      ]),
    );
  }
}
