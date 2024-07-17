import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/features/checkout/provider/checkout_provider.dart';
import 'package:yml_ecommerce_test/features/offline_payment/domain/model/offline_payment_model.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/utill/custom_themes.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/features/checkout/widget/shipping_details_widget.dart';
import 'package:provider/provider.dart';

class OfflineCard extends StatelessWidget {
  final int index;
  final OfflineMethods offlinePaymentModel;
  const OfflineCard({super.key, required this.offlinePaymentModel, required this.index});

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckOutProvider>(
      builder: (context, orderProvider, _) {
        return Stack(children: [
            Padding(padding: const EdgeInsets.fromLTRB(0, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault),
              child: Container(width: MediaQuery.of(context).size.width *.75, height: 180, decoration: BoxDecoration(
                color: index == orderProvider.offlineMethodSelectedIndex? Theme.of(context).cardColor : Theme.of(context).primaryColor.withOpacity(.125),
                border: index == orderProvider.offlineMethodSelectedIndex? Border.all(color: Theme.of(context).primaryColor.withOpacity(.5), width: .5): null,
                borderRadius: BorderRadius.circular((Dimensions.paddingSizeExtraSmall))

              ),padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,children: [
                    Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge, bottom: Dimensions.paddingSizeExtraSmall ),
                      child: Text(offlinePaymentModel.methodName??'', style: textBold.copyWith(color: Theme.of(context).primaryColor,
                          fontSize: Dimensions.fontSizeLarge)),),
                      ListView.builder(
                        itemCount: offlinePaymentModel.methodFields?.length,
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index){
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraExtraSmall),
                            child: Row(children: [
                              Text('${offlinePaymentModel.methodFields?[index].inputName??''} : '.replaceAll("_", " ").capitalize(),
                                style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault),),
                              Text((offlinePaymentModel.methodFields?[index].inputData??'').replaceAll('_', " ").capitalize(),
                                style: textMedium.copyWith(fontSize: Dimensions.fontSizeLarge),)
                            ],),
                          );
                      }),
                    ],
                  )),
            ),
            if(index == orderProvider.offlineMethodSelectedIndex)
            Positioned(top: 30, right: 20,
              child: Row(children: [
                Text('${getTranslated('pay_on_this_account', context)}',style: textRegular.copyWith(color: Theme.of(context).primaryColor),),
                const Padding(padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                  child: Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Colors.green, size: 18),
                ),

              ],),
            )
          ],
        );
      }
    );
  }
}
