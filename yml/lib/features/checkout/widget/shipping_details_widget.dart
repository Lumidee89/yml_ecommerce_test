import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/features/address/controllers/address_controller.dart';
import 'package:yml_ecommerce_test/features/checkout/provider/checkout_provider.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/utill/custom_themes.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/utill/images.dart';
import 'package:yml_ecommerce_test/features/address/views/saved_address_list_screen.dart';
import 'package:yml_ecommerce_test/features/address/views/saved_billing_address_list_screen.dart';
import 'package:provider/provider.dart';


class ShippingDetailsWidget extends StatelessWidget {
  final bool hasPhysical;
  final bool billingAddress;
  const ShippingDetailsWidget({super.key, required this.hasPhysical, required this.billingAddress});

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckOutProvider>(
        builder: (context, shippingProvider,_) {
          return Consumer<AddressController>(
            builder: (context, locationProvider, _) {
              return Container(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeSmall, Dimensions.paddingSizeSmall, Dimensions.paddingSizeSmall,0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  hasPhysical?
                  Card(child: Container(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                      color: Theme.of(context).cardColor,),
                    child: Column(crossAxisAlignment:CrossAxisAlignment.start, children: [
                      Row(mainAxisAlignment:MainAxisAlignment.start, crossAxisAlignment:CrossAxisAlignment.start, children: [
                        Expanded(child: Row(children: [
                          SizedBox(width: 18, child: Image.asset(Images.deliveryTo)),
                          Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                            child: Text('${getTranslated('delivery_to', context)}',
                                style: titilliumRegular.copyWith(fontWeight: FontWeight.w600)))])),


                        InkWell(onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) => const SavedAddressListScreen())),
                          child: SizedBox(width: 20, child: Image.asset(Images.edit, scale: 3, color: Theme.of(context).primaryColor,)),),]),
                      const SizedBox(height: Dimensions.paddingSizeDefault,),

                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text((shippingProvider.addressIndex == null || locationProvider.addressList!.isEmpty) ?
                        '${getTranslated('address_type', context)}' :
                        locationProvider.addressList![shippingProvider.addressIndex!].addressType!.capitalize(),
                          style: titilliumBold.copyWith(fontSize: Dimensions.fontSizeLarge), maxLines: 3, overflow: TextOverflow.fade),
                        const Divider(thickness: .125),


                        (shippingProvider.addressIndex == null || locationProvider.addressList!.isEmpty)?
                        Text(getTranslated('add_your_address', context)??'',
                          style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                          maxLines: 3, overflow: TextOverflow.fade):
                        Column(children: [
                          AddressInfoItem(icon: Images.user, title: locationProvider.addressList![shippingProvider.addressIndex!].contactPersonName??''),
                          AddressInfoItem(icon: Images.callIcon, title: locationProvider.addressList![shippingProvider.addressIndex!].phone??''),
                          AddressInfoItem(icon: Images.address, title: locationProvider.addressList![shippingProvider.addressIndex!].address??''),])])]))): const SizedBox(),
                      SizedBox(height: hasPhysical? Dimensions.paddingSizeSmall:0),


                      billingAddress?
                      Card(child: Container(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                            color: Theme.of(context).cardColor),
                          child: Column(crossAxisAlignment:CrossAxisAlignment.start, children: [
                            Row(mainAxisAlignment:MainAxisAlignment.start, crossAxisAlignment:CrossAxisAlignment.start, children: [
                              Expanded(child: Row(children: [
                                SizedBox(width: 18, child: Image.asset(Images.billingTo)),
                                Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                    child: Text('${getTranslated('billing_to', context)}',
                                        style: titilliumRegular.copyWith(fontWeight: FontWeight.w600)))])),


                              InkWell(onTap: () => Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => const SavedBillingAddressListScreen())),
                                child: SizedBox(width: 20,child: Image.asset(Images.edit, scale: 3, color: Theme.of(context).primaryColor,)),),]),


                              const SizedBox(height: Dimensions.paddingSizeDefault,),
                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text((shippingProvider.billingAddressIndex == null || locationProvider.billingAddressList.isEmpty) ?
                                  '${getTranslated('address_type', context)}'
                                        : locationProvider.billingAddressList[
                                  shippingProvider.billingAddressIndex!].addressType!.capitalize(),
                                    style: titilliumBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                                    maxLines: 1, overflow: TextOverflow.fade,
                                  ),
                                  const Divider(thickness: .125),

                                  (shippingProvider.billingAddressIndex == null || locationProvider.billingAddressList.isEmpty)?
                                  Text(getTranslated('add_your_address', context)!,
                                    style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall), maxLines: 3, overflow: TextOverflow.fade,):

                                  Column(children: [
                                    AddressInfoItem(icon: Images.user, title: locationProvider.billingAddressList[shippingProvider.billingAddressIndex!].contactPersonName??''),
                                    AddressInfoItem(icon: Images.callIcon, title: locationProvider.billingAddressList[shippingProvider.billingAddressIndex!].phone??''),
                                    AddressInfoItem(icon: Images.address, title: locationProvider.billingAddressList[shippingProvider.billingAddressIndex!].address??''),

                                  ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ):const SizedBox(),
                    ]),
              );
            }
          );
        }
    );
  }
}

class AddressInfoItem extends StatelessWidget {
  final String? icon;
  final String? title;
  const AddressInfoItem({super.key, this.icon, this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
      child: Row(children: [
        SizedBox(width: 18, child: Image.asset(icon!)),
        Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            child: Text(title??'',style: textRegular.copyWith(),maxLines: 2, overflow: TextOverflow.fade )))]),
    );
  }
}
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}