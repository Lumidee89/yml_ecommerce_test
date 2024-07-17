import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/features/cart/controllers/cart_controller.dart';
import 'package:yml_ecommerce_test/features/notification/provider/notification_provider.dart';
import 'package:yml_ecommerce_test/utill/color_resources.dart';
import 'package:yml_ecommerce_test/utill/custom_themes.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/utill/images.dart';
import 'package:yml_ecommerce_test/features/cart/views/cart_screen.dart';
import 'package:yml_ecommerce_test/features/notification/view/notification_screen.dart';
import 'package:provider/provider.dart';

class CartWidgetHomePage extends StatelessWidget {
  const CartWidgetHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Consumer<NotificationProvider>(
          builder: (context, notificationProvider, _) {
            return IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationScreen())),
              icon: Stack(clipBehavior: Clip.none, children: [
                Image.asset(Images.notification,
                    height: Dimensions.iconSizeDefault,
                    width: Dimensions.iconSizeDefault,
                    color: ColorResources.getPrimary(context)),
                Positioned(top: -4, right: -4,
                  child: CircleAvatar(radius: 7, backgroundColor: ColorResources.red,
                    child: Text(notificationProvider.notificationModel?.newNotificationItem.toString() ?? '0',
                        style: titilliumSemiBold.copyWith(color: ColorResources.white, fontSize: Dimensions.fontSizeExtraSmall,
                        )),
                  ),
                ),

              ]),
            );
          }
        ),

        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
            icon: Stack(clipBehavior: Clip.none, children: [
              Image.asset(Images.cartArrowDownImage,
                  height: Dimensions.iconSizeDefault,
                  width: Dimensions.iconSizeDefault,
                  color: ColorResources.getPrimary(context)),
              Positioned(top: -4, right: -4,
                child: Consumer<CartController>(builder: (context, cart, child) {
                  return CircleAvatar(radius: 7, backgroundColor: ColorResources.red,
                    child: Text(cart.cartList.length.toString(),
                        style: titilliumSemiBold.copyWith(color: ColorResources.white, fontSize: Dimensions.fontSizeExtraSmall,
                        )),
                  );
                }),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
