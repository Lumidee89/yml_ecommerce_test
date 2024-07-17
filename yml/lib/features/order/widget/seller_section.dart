import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/features/auth/controllers/auth_controller.dart';
import 'package:yml_ecommerce_test/features/chat/provider/chat_provider.dart';
import 'package:yml_ecommerce_test/features/order/provider/order_provider.dart';
import 'package:yml_ecommerce_test/utill/images.dart';
import 'package:yml_ecommerce_test/basewidget/not_logged_in_bottom_sheet.dart';
import 'package:yml_ecommerce_test/features/chat/view/chat_screen.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/utill/custom_themes.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/basewidget/show_custom_snakbar.dart';
import 'package:provider/provider.dart';

class SellerSection extends StatelessWidget {
  final OrderProvider? order;
  const SellerSection({super.key, this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      color: Theme.of(context).highlightColor,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        InkWell(onTap: (){
          if(Provider.of<AuthController>(context, listen: false).isLoggedIn()){
            Provider.of<ChatProvider>(context, listen: false).setUserTypeIndex(context, 0);
            if(order!.orderDetails![0].seller != null){
              Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(
                id: order!.orderDetails![0].seller!.id,
                name: order!.orderDetails![0].seller!.shop!.name)));
            }else{
              showCustomSnackBar(getTranslated('seller_not_available', context), context,isToaster: true);
            }
          }else{
            showModalBottomSheet(backgroundColor: Colors.transparent, context: context, builder: (_)=> const NotLoggedInBottomSheet());}
          },
              child: Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                child: Row(children: [
                  Icon(Icons.storefront_outlined, color: Theme.of(context).primaryColor, size: 20),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                  if( order != null && order!.orderDetails != null && order!.orderDetails != null && order!.orderDetails!.isNotEmpty)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(maxLines: 1, overflow: TextOverflow.ellipsis,
                      (order?.orderDetails != null && order!.orderDetails!.isNotEmpty && order!.orderDetails![0].seller == null )? 'Admin' :
                      '${order?.orderDetails?[0].seller?.shop?.name??'${getTranslated('seller_not_available', context)}'} ',
                      style: textRegular.copyWith(),
                    ),
                  ),
                  const Spacer(),

                  SizedBox(width: Dimensions.iconSizeDefault, child: Image.asset(Images.chat))

                ]),
              ),
            ),
          ]),
    );
  }
}
