import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/features/checkout/provider/checkout_provider.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/features/splash/provider/splash_provider.dart';
import 'package:yml_ecommerce_test/utill/custom_themes.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/utill/images.dart';
import 'package:yml_ecommerce_test/basewidget/custom_image.dart';
import 'package:yml_ecommerce_test/features/checkout/widget/payment_method_bottom_sheet.dart';
import 'package:provider/provider.dart';

class ChoosePaymentSection extends StatelessWidget {
  final bool onlyDigital;
  const ChoosePaymentSection({super.key, required this.onlyDigital});

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckOutProvider>(
      builder: (context, orderProvider,_) {
        return Consumer<SplashProvider>(
          builder: (context, configProvider, _) {
            return Card(
              child: Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                  color: Theme.of(context).cardColor,
                ),
                child: Column(crossAxisAlignment:CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment:MainAxisAlignment.start, crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Text('${getTranslated('payment_method', context)}',
                            style: titilliumRegular.copyWith(fontWeight: FontWeight.w600))),


                        InkWell(
                          onTap: () => showModalBottomSheet(context: context,
                              isScrollControlled: true, backgroundColor: Colors.transparent,
                              builder: (c) =>   PaymentMethodBottomSheet(onlyDigital: onlyDigital,)),
                          child: SizedBox(width: 20, child: Image.asset(Images.edit, scale: 3)),
                        ),

                      ],
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault,),

                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      const Divider(thickness: .125,),


                      (orderProvider.paymentMethodIndex != -1)?
                          Row(children: [
                            SizedBox(width: 40, child: CustomImage(image: '${configProvider.configModel?.paymentMethodImagePath}/${configProvider.configModel!.paymentMethods![orderProvider.paymentMethodIndex].additionalDatas!.gatewayImage??''}')),
                            Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                              child: Text(configProvider.configModel!.paymentMethods![orderProvider.paymentMethodIndex].additionalDatas!.gatewayTitle??''),),
                          ],):orderProvider.codChecked?
                          Text(getTranslated('cash_on_delivery', context)??'')
                          :orderProvider.offlineChecked?
                      Text(getTranslated('offline_payment', context)??'')
                          :orderProvider.walletChecked?
                      Text(getTranslated('wallet_payment', context)??'')
                          :
                      InkWell(onTap: () => showModalBottomSheet(context: context,
                          isScrollControlled: true, backgroundColor: Colors.transparent,
                          builder: (c) =>   PaymentMethodBottomSheet(onlyDigital: onlyDigital,)),
                        child: Row(children: [
                          Padding(padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                            child: Icon(Icons.add_circle_outline_outlined, size: 20, color: Theme.of(context).primaryColor),),
                            Text('${getTranslated('add_payment_method', context)}',
                              style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                              maxLines: 3, overflow: TextOverflow.fade,
                            ),
                          ],
                        ),
                      ),
                    ],
                    ),
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }
}
