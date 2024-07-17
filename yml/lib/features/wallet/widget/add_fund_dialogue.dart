
import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/features/checkout/provider/checkout_provider.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/features/splash/provider/splash_provider.dart';
import 'package:yml_ecommerce_test/theme/provider/theme_provider.dart';
import 'package:yml_ecommerce_test/features/wallet/provider/wallet_provider.dart';
import 'package:yml_ecommerce_test/utill/custom_themes.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/basewidget/custom_button.dart';
import 'package:yml_ecommerce_test/basewidget/show_custom_snakbar.dart';
import 'package:yml_ecommerce_test/features/checkout/widget/custom_check_box.dart';
import 'package:provider/provider.dart';


class AddFundDialogue extends StatelessWidget {
  const AddFundDialogue({super.key, required this.focusNode, required this.inputAmountController});
  final FocusNode focusNode;
  final TextEditingController inputAmountController;

  @override
  Widget build(BuildContext context) {
    return Material(color: Colors.transparent,
      child: Padding(padding: const EdgeInsets.all(8.0),
        child: Consumer<CheckOutProvider>(
          builder: (context, digitalPaymentProvider,_) {
            return Consumer<SplashProvider>(
              builder: (context, configProvider,_) {
                return SingleChildScrollView(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                      child: InkWell(onTap: () => Navigator.pop(context),
                          child: Align(alignment: Alignment.topRight,child: Icon(Icons.cancel, color: Theme.of(context).hintColor, size: 30,))),),

                    Container(decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault)),
                      child: Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeSmall, Dimensions.paddingSizeExtraLarge, Dimensions.paddingSizeSmall, Dimensions.paddingSizeDefault),
                        child: Column(children: [
                          Text(getTranslated('add_fund_to_wallet', context)!, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                          Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeDefault),
                            child: Text(getTranslated('add_fund_form_secured_digital_payment_gateways', context)!, style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center),),


                          Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                            child: Container(decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                              border: Border.all(width: .5,color: Provider.of<ThemeProvider>(context, listen: false).darkTheme? Theme.of(context).hintColor : Theme.of(context).primaryColor.withOpacity(.5))),
                              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Text(Provider.of<SplashProvider>(context, listen: false).myCurrency!.symbol!,
                                      style: textBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge,color:  Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(.75) )),
                                  IntrinsicWidth(
                                    child: TextField(
                                      controller: inputAmountController,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.done,
                                      textAlign: TextAlign.center,
                                      style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        border: InputBorder.none,
                                        hintText: 'Ex: 500')))]))),


                          Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall,
                              top: Dimensions.paddingSizeDefault, left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault),
                            child: Row(children: [
                              Text('${getTranslated('add_money_via_online', context)}',
                                  style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                              Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
                                child: Text('${getTranslated('fast_and_secure', context)}',
                                    style: textRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).hintColor)))])),


                          Consumer<SplashProvider>(
                              builder: (context, configProvider,_) {
                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: configProvider.configModel?.paymentMethods?.length??0,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index){
                                    return  CustomCheckBox(index: index,
                                      icon: '${configProvider.configModel?.paymentMethodImagePath}/${configProvider.configModel?.paymentMethods?[index].additionalDatas?.gatewayImage??''}',
                                      name: configProvider.configModel!.paymentMethods![index].keyName!,
                                      title: configProvider.configModel!.paymentMethods![index].additionalDatas?.gatewayTitle??'');
                                  },
                                );
                              }),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                            child: CustomButton(
                              buttonText: getTranslated('add_fund', context)!,
                              onTap: () {
                                if(digitalPaymentProvider.selectedDigitalPaymentMethodName.isEmpty){
                                  digitalPaymentProvider.setDigitalPaymentMethodName(0,configProvider.configModel!.paymentMethods![0].keyName!);
                                }
                                if(inputAmountController.text.trim().isEmpty){
                                  showCustomSnackBar('${getTranslated('please_input_amount', context)}', context);
                                }else if(double.parse(inputAmountController.text.trim()) <= 0){
                                  showCustomSnackBar('${getTranslated('please_input_amount', context)}', context);
                                }else if(digitalPaymentProvider.paymentMethodIndex == -1){
                                  showCustomSnackBar('${getTranslated('please_select_any_payment_type', context)}', context);
                                }else{
                                  Provider.of<WalletTransactionProvider>(context, listen: false).addFundToWallet(inputAmountController.text.trim(), digitalPaymentProvider.selectedDigitalPaymentMethodName);
                                }
                              },
                            ),
                          ),
                        ],),
                      ),
                    ),

                  ],),
                );
              }
            );
          }
        ),
      ),
    );
  }
}