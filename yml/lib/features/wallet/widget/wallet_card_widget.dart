import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/helper/price_converter.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/features/splash/provider/splash_provider.dart';
import 'package:yml_ecommerce_test/features/wallet/provider/wallet_provider.dart';
import 'package:yml_ecommerce_test/utill/custom_themes.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/features/wallet/widget/add_fund_dialogue.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:provider/provider.dart';

class WalletCardWidget extends StatelessWidget {
  const WalletCardWidget({super.key, required this.tooltipController, required this.focusNode,
    required this.inputAmountController});

  final JustTheController tooltipController;
  final FocusNode focusNode;
  final TextEditingController inputAmountController;

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletTransactionProvider>(builder: (context, profile, _) {
      return Row(children: [
          Expanded(flex: 8,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(getTranslated('wallet_amount', context)!,
                    style:  textRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeLarge)),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Row(children: [
                    Text(PriceConverter.convertPrice(context,
                        (profile.walletBalance != null && profile.walletBalance!.totalWalletBalance != null) ? profile.walletBalance!.totalWalletBalance ?? 0 : 0),
                        style:  textBold.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeOverLarge)),

                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                    JustTheTooltip(backgroundColor: Colors.black87,
                      controller: tooltipController,
                      preferredDirection: AxisDirection.down,
                      tailLength: 10,
                      tailBaseWidth: 20,
                      content: Container(width: MediaQuery.of(context).size.width * 0.57,
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: Text(getTranslated('if_you_want_to_add_fund_to_your_wallet_then_click_add_fund_button', context)!,
                            style: textRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeDefault))),
                      child: InkWell(onTap: () => tooltipController.showTooltip(),
                        child: const Icon(Icons.info_outline, color: Colors.white))),
                  ],
                ),
              ],
            ),
          ),
          if(Provider.of<SplashProvider>(context, listen: false).configModel?.addFundsToWallet == 1)
          Expanded(child: InkWell(onTap: () {
                showDialog(context: context, builder: (BuildContext context) {
                  return AddFundDialogue(focusNode: focusNode, inputAmountController: inputAmountController);
                });
              },
              child: Container(decoration: (const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                child: Icon(Icons.add, color: Theme.of(context).primaryColor, size: 20)),
            ),
          ),
        ],
      );
    });
  }
}
