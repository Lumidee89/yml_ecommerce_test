import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/features/auth/controllers/auth_controller.dart';
import 'package:yml_ecommerce_test/features/coupon/provider/coupon_provider.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/utill/images.dart';
import 'package:yml_ecommerce_test/basewidget/custom_app_bar.dart';
import 'package:yml_ecommerce_test/basewidget/no_internet_screen.dart';
import 'package:yml_ecommerce_test/basewidget/not_loggedin_widget.dart';
import 'package:yml_ecommerce_test/features/coupon/widget/coupon_item.dart';
import 'package:yml_ecommerce_test/features/order/widget/order_shimmer.dart';
import 'package:provider/provider.dart';

class CouponList extends StatefulWidget {
  const CouponList({super.key});

  @override
  State<CouponList> createState() => _CouponListState();
}

class _CouponListState extends State<CouponList> {
  @override
  void initState() {
    if(Provider.of<AuthController>(context, listen: false).isLoggedIn()){
      Provider.of<CouponProvider>(context, listen: false).getCouponList(context, 1);

    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('coupons', context)),
      body: Provider.of<AuthController>(context, listen: false).isLoggedIn()?

      Consumer<CouponProvider>(
          builder: (context, couponProvider,_) {
            return couponProvider.couponList != null? couponProvider.couponList!.isNotEmpty?
            Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: couponProvider.couponList!.length,
                  itemBuilder: (context, index){
                    return CouponItem(coupons: couponProvider.couponList![index]);
                  }),
            ) : const NoInternetOrDataScreen(isNoInternet: false,
              icon: Images.noCoupon, message: 'no_coupon_available') : const OrderShimmer();
          }
      ): const NotLoggedInWidget(),
    );
  }
}