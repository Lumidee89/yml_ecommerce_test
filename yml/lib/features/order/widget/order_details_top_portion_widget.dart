import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/helper/date_converter.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/features/order/provider/order_provider.dart';
import 'package:yml_ecommerce_test/utill/color_resources.dart';
import 'package:yml_ecommerce_test/utill/custom_themes.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/features/dashboard/dashboard_screen.dart';

class OrderDetailTopPortion extends StatelessWidget {
  final OrderProvider orderProvider;
  final bool fromNotification;
  const OrderDetailTopPortion({super.key, required this.orderProvider, this.fromNotification = false});

  @override
  Widget build(BuildContext context) {
    return orderProvider.orders != null?
    Stack(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center, children: [
                RichText(text: TextSpan(
                    text: '${getTranslated('order', context)}# ',
                    style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeDefault), children:[
                      TextSpan(text: orderProvider.orders?.id.toString(),
                          style: textBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeLarge)),
                    ],
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall,),

                RichText(text: TextSpan(
                    text: getTranslated('your_order_is', context),
                    style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: ColorResources.getHint(context)),
                    children:[
                      TextSpan(text: ' ${getTranslated('${orderProvider.orders?.orderStatus}', context)}',
                          style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge,
                            color: orderProvider.orders?.orderStatus == 'delivered'?
                            ColorResources.getGreen(context) : orderProvider.orders!.orderStatus == 'pending'?
                            ColorResources.getYellow(context) : orderProvider.orders!.orderStatus == 'confirmed'?
                            Theme.of(context).primaryColor : ColorResources.getGreen(context)))]),),
                const SizedBox(height: Dimensions.paddingSizeSmall,),

                Text(DateConverter.localDateToIsoStringAMPMOrder(DateTime.parse(orderProvider.orders!.createdAt!)),
                    style: titilliumRegular.copyWith(color: ColorResources.getHint(context),
                        fontSize: Dimensions.fontSizeSmall)),
              ],
            ),
          ],
        ),
        InkWell(onTap: (){
          if(fromNotification){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => const DashBoardScreen()));
          }else{
            Navigator.pop(context);
          }
        }, child: const Padding(padding: EdgeInsets.symmetric(vertical : Dimensions.paddingSizeDefault),
            child: Icon(CupertinoIcons.back)))
      ],
    ): const SizedBox();
  }
}
