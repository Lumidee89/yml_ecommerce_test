import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/features/checkout/provider/checkout_provider.dart';
import 'package:yml_ecommerce_test/theme/provider/theme_provider.dart';
import 'package:yml_ecommerce_test/utill/custom_themes.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/basewidget/custom_image.dart';
import 'package:provider/provider.dart';

class CustomCheckBox extends StatelessWidget {
  final int index;
  final bool isDigital;
  final String? icon;
  final String name;
  final String title;
  const CustomCheckBox({super.key,  required this.index, this.isDigital =  false, this.icon, required this.name, required this.title});

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckOutProvider>(
      builder: (context, order, child) {
        return InkWell(onTap: () => order.setDigitalPaymentMethodName(index, name),
          child: Padding(padding: const EdgeInsets.all(8.0),
            child: Container(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),),
              child: Row(children: [
                Theme(
                  data: Theme.of(context).copyWith(
                    unselectedWidgetColor: Provider.of<ThemeProvider>(context, listen: false).darkTheme? Theme.of(context).hintColor.withOpacity(.5) : Theme.of(context).primaryColor.withOpacity(.25),
                  ),
                  child: Checkbox(
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraLarge)),
                    value: order.paymentMethodIndex == index,
                    activeColor: Colors.green,
                    onChanged: (bool? isChecked) => order.setDigitalPaymentMethodName(index, name),
                  ),
                ),
                SizedBox(width: 40, child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  child: CustomImage(image : icon!),
                )),
                Text(title, style: textRegular.copyWith(),),

              ]),
            ),
          ),
        );
      },
    );
  }
}
