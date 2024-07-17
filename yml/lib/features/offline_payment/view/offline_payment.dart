import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/features/address/controllers/address_controller.dart';
import 'package:yml_ecommerce_test/features/checkout/provider/checkout_provider.dart';
import 'package:yml_ecommerce_test/helper/price_converter.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/features/coupon/provider/coupon_provider.dart';
import 'package:yml_ecommerce_test/features/profile/provider/profile_provider.dart';
import 'package:yml_ecommerce_test/features/splash/provider/splash_provider.dart';
import 'package:yml_ecommerce_test/utill/custom_themes.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/utill/images.dart';
import 'package:yml_ecommerce_test/basewidget/custom_app_bar.dart';
import 'package:yml_ecommerce_test/basewidget/custom_textfield.dart';
import 'package:yml_ecommerce_test/basewidget/show_custom_snakbar.dart';
import 'package:yml_ecommerce_test/features/checkout/widget/proced_button.dart';
import 'package:yml_ecommerce_test/features/checkout/widget/shipping_details_widget.dart';
import 'package:yml_ecommerce_test/features/offline_payment/widget/offline_card.dart';
import 'package:provider/provider.dart';

class OfflinePaymentScreen extends StatefulWidget {
  final double payableAmount;
  final Function callback;
  const OfflinePaymentScreen({super.key, required this.payableAmount, required this.callback});

  @override
  State<OfflinePaymentScreen> createState() => _OfflinePaymentScreenState();
}

class _OfflinePaymentScreenState extends State<OfflinePaymentScreen> {
   TextEditingController paymentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('offline_payment', context)),
      body: Consumer<CheckOutProvider>(
        builder: (context, checkoutProvider, _) {
          return CustomScrollView(slivers: [
            SliverToBoxAdapter(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.min, children: [
                Center(child: SizedBox(height: 100, child: Image.asset(Images.offlinePayment))),
                Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: Text('${getTranslated('offline_payment_helper_text', context)}', textAlign: TextAlign.center,
                      style: textRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeDefault)),),

                if(checkoutProvider.offlinePaymentModel != null && checkoutProvider.offlinePaymentModel!.offlineMethods != null && checkoutProvider.offlinePaymentModel!.offlineMethods!.isNotEmpty)
                  SizedBox(height: 190,
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: checkoutProvider.offlinePaymentModel!.offlineMethods!.length,
                          itemBuilder: (context, index){
                            return InkWell(onTap: (){
                              if(checkoutProvider.offlinePaymentModel?.offlineMethods != null && checkoutProvider.offlinePaymentModel!.offlineMethods!.isNotEmpty){
                                checkoutProvider.setOfflinePaymentMethodSelectedIndex(index);
                              }
                            },
                                child: OfflineCard(offlinePaymentModel: checkoutProvider.offlinePaymentModel!.offlineMethods![index], index: index));
                          })),


                Center(child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: Text('${getTranslated('amount', context)} : ${PriceConverter.convertPrice(context, widget.payableAmount)}',
                        style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge)))),


                Text('${getTranslated('payment_info', context)}', style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge),),

                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: checkoutProvider.offlinePaymentModel!.offlineMethods![checkoutProvider.offlineMethodSelectedIndex].methodInformations?.length,
                    itemBuilder: (context, index){

                      return Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                        child: CustomTextField(
                          controller: checkoutProvider.inputFieldControllerList[index],
                          required: checkoutProvider.offlinePaymentModel!.offlineMethods![checkoutProvider.offlineMethodSelectedIndex].methodInformations?[index].isRequired == 1,
                          labelText: '${checkoutProvider.offlinePaymentModel!.offlineMethods![checkoutProvider.offlineMethodSelectedIndex].methodInformations?[index].customerInput}'.replaceAll('_', ' ').capitalize(),
                          hintText: '${checkoutProvider.offlinePaymentModel!.offlineMethods![checkoutProvider.offlineMethodSelectedIndex].methodInformations?[index].customerPlaceholder}'.replaceAll('_', ' ').capitalize(),
                        ),
                      );
                    }),

                const SizedBox(height: 20,),

                CustomTextField(controller: paymentController,
                labelText:  getTranslated('note', context),
                hintText: getTranslated('note', context),),

                const SizedBox(height: 20,),


              ],),
            ),)
          ],);
        }
      ),
      bottomNavigationBar: Consumer<CheckOutProvider>(
        builder: (context, checkoutProvider, _) {
          return Consumer<ProfileProvider>(
            builder: (context, profileProvider,_) {
              return Consumer<CouponProvider>(
                builder: (context, couponProvider,_) {
                  return Consumer<AddressController>(
                    builder: (context, locationProvider,_) {
                      return InkWell(
                        onTap: (){bool emptyRequiredField = false;
                          for(int i = 0; i< checkoutProvider.offlinePaymentModel!.offlineMethods![checkoutProvider.offlineMethodSelectedIndex].methodInformations!.length; i++){
                            if(checkoutProvider.offlinePaymentModel!.offlineMethods![checkoutProvider.offlineMethodSelectedIndex].methodInformations![i].isRequired == 1 && checkoutProvider.inputFieldControllerList[i].text.isEmpty){
                              emptyRequiredField = true;
                              break;
                            }
                          }

                          if(emptyRequiredField){
                            showCustomSnackBar('${getTranslated('fill_all_required_fill', context)}', context);
                          }
                          else{
                            String paymentNote = paymentController.text.trim();
                            String orderNote = checkoutProvider.orderNoteController.text.trim();
                            String couponCode = couponProvider.discount != null && couponProvider.discount != 0? couponProvider.couponCode : '';
                            String couponCodeAmount = couponProvider.discount != null && couponProvider.discount != 0? couponProvider.discount.toString() : '0';
                            String addressId = checkoutProvider.addressIndex != null ?locationProvider.addressList![checkoutProvider.addressIndex!].id.toString():'';
                            String billingAddressId = (Provider.of<SplashProvider>(context, listen: false).configModel!.billingInputByCustomer == 1)?
                            locationProvider.billingAddressList[checkoutProvider.billingAddressIndex!].id.toString() : '';
                            checkoutProvider.placeOrder(callback: widget.callback,
                                paymentNote: paymentNote,
                                addressID: addressId, billingAddressId: billingAddressId,
                                orderNote: orderNote, couponCode: couponCode, couponAmount: couponCodeAmount, isfOffline: true);
                          }

                        }, child: const ProceedButton());
                    }
                  );
                }
              );
            }
          );
        }
      ),
    );
  }
}
