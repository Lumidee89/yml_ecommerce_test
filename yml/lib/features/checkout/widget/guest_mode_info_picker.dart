import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/features/address/controllers/address_controller.dart';
import 'package:yml_ecommerce_test/features/checkout/provider/checkout_provider.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/utill/custom_themes.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/utill/images.dart';
import 'package:yml_ecommerce_test/features/checkout/widget/shipping_details_widget.dart';
import 'package:provider/provider.dart';

class GuestModeInfoPicker extends StatelessWidget {
  final String icon;
  final String title;
  final String subTitle;
  const GuestModeInfoPicker({super.key, required this.icon, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddressController>(
      builder: (context,locationProvider,_) {
        return Consumer<CheckOutProvider>(
          builder: (context, checkoutProvider,_) {
            return Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                  border: Border.all(width: 0.75, color: Theme.of(context).primaryColor.withOpacity(.25)),

                ),
                child: Column(children: [
                  Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Expanded(
                        child: Row(children: [
                          SizedBox(width: 25, child: Image.asset(icon)),
                          Text('${getTranslated(title, context)}', style: textMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge),)
                        ],),
                      ),
                      SizedBox(width: 25, child: Image.asset(Images.edit))
                    ],),
                  ),

                  const Padding(padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                      child: Divider()),

                  if(checkoutProvider.addressIndex == null)
                  Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: SizedBox(width: 25, child: Image.asset(Images.contactInfoIcon))),

                  checkoutProvider.addressIndex == null ?
                  Padding(padding: const EdgeInsets.only(bottom : Dimensions.paddingSizeExtraLarge),
                    child: Text('${getTranslated(subTitle, context)}',
                      style: textRegular.copyWith(color: Theme.of(context).hintColor),),):

                  Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: (locationProvider.addressList != null && locationProvider.addressList!.isNotEmpty)?
                    Column(children: [
                      AddressInfoItem(icon: Images.user, title: locationProvider.addressList![checkoutProvider.addressIndex!].contactPersonName??''),
                      AddressInfoItem(icon: Images.callIcon, title: locationProvider.addressList![checkoutProvider.addressIndex!].phone??''),
                      AddressInfoItem(icon: Images.address, title: locationProvider.addressList![checkoutProvider.addressIndex!].address??''),

                    ],
                    ):const SizedBox(),
                  ),

                ],),
              ),
            );
          }
        );
      }
    );
  }
}
