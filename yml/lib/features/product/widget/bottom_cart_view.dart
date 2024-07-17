// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/features/product/domain/model/product_details_model.dart';
import 'package:yml_ecommerce_test/features/product/provider/product_details_provider.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/features/cart/controllers/cart_controller.dart';
import 'package:yml_ecommerce_test/theme/provider/theme_provider.dart';
import 'package:yml_ecommerce_test/utill/color_resources.dart';
import 'package:yml_ecommerce_test/utill/custom_themes.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/utill/images.dart';
import 'package:yml_ecommerce_test/basewidget/show_custom_snakbar.dart';
import 'package:yml_ecommerce_test/features/cart/views/cart_screen.dart';
import 'package:yml_ecommerce_test/features/product/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../provider/product_provider.dart';

class BottomCartView extends StatefulWidget {
  ProductDetailsModel? product;
  String? productSlug;
  int? productId;
  BottomCartView({super.key, this.product, this.productSlug, this.productId});

  @override
  State<BottomCartView> createState() => _BottomCartViewState();
}

class _BottomCartViewState extends State<BottomCartView> {
  bool vacationIsOn = false;
  bool temporaryClose = false;

  _loadData(BuildContext context) async {
    widget.product =
        await Provider.of<ProductDetailsProvider>(context, listen: false)
            .getProductDetailsTwo(context, widget.productSlug.toString());
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .removePrevReview();
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .initProduct(widget.productId, widget.productSlug, context);
    Provider.of<ProductProvider>(context, listen: false)
        .removePrevRelatedProduct();
    Provider.of<ProductProvider>(context, listen: false)
        .initRelatedProductList(widget.productId.toString(), context);
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .getCount(widget.productId.toString(), context);
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .getSharableLink(widget.productSlug.toString(), context);
  }

  @override
  void initState() {
    super.initState();

    if (widget.productId == null && widget.productSlug == null) {
      if (widget.product != null &&
          widget.product!.seller != null &&
          widget.product!.seller!.shop!.vacationEndDate != null) {
        DateTime vacationDate =
            DateTime.parse(widget.product!.seller!.shop!.vacationEndDate!);
        DateTime vacationStartDate =
            DateTime.parse(widget.product!.seller!.shop!.vacationStartDate!);
        final today = DateTime.now();
        final difference = vacationDate.difference(today).inDays;
        final startDate = vacationStartDate.difference(today).inDays;

        if (difference >= 0 &&
            widget.product!.seller!.shop!.vacationStatus! &&
            startDate <= 0) {
          vacationIsOn = true;
        } else {
          vacationIsOn = false;
        }
      }

      if (widget.product != null &&
          widget.product!.seller != null &&
          widget.product!.seller!.shop!.temporaryClose!) {
        temporaryClose = true;
      } else {
        temporaryClose = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        boxShadow: widget.productId != null
            ? []
            : [
                BoxShadow(
                  color: Theme.of(context).hintColor,
                  blurRadius: .5,
                  spreadRadius: .1,
                )
              ],
      ),
      child: Row(children: [
        widget.productId != null
            ? const SizedBox()
            : Expanded(
                flex: 3,
                child: Padding(
                  padding:
                      const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  child: Stack(children: [
                    GestureDetector(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const CartScreen())),
                        child: Image.asset(Images.cartArrowDownImage,
                            color: ColorResources.getPrimary(context))),
                    Positioned(
                      top: 0,
                      right: 10,
                      child: Consumer<CartController>(
                          builder: (context, cart, child) {
                        return Container(
                          height: 17,
                          width: 17,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorResources.getPrimary(context),
                          ),
                          child: Text(
                            cart.cartList.length.toString(),
                            style: titilliumSemiBold.copyWith(
                                fontSize: Dimensions.fontSizeExtraSmall,
                                color: Theme.of(context).highlightColor),
                          ),
                        );
                      }),
                    )
                  ]),
                )),
        Expanded(
            flex: 11,
            child: InkWell(
              onTap: () async {
                if (widget.productId != null && widget.productSlug != null) {
                  await _loadData(context);

                  if (widget.product != null &&
                      widget.product!.seller != null &&
                      widget.product!.seller!.shop!.vacationEndDate != null) {
                    DateTime vacationDate = DateTime.parse(
                        widget.product!.seller!.shop!.vacationEndDate!);
                    DateTime vacationStartDate = DateTime.parse(
                        widget.product!.seller!.shop!.vacationStartDate!);
                    final today = DateTime.now();
                    final difference = vacationDate.difference(today).inDays;
                    final startDate =
                        vacationStartDate.difference(today).inDays;

                    if (difference >= 0 &&
                        widget.product!.seller!.shop!.vacationStatus! &&
                        startDate <= 0) {
                      vacationIsOn = true;
                    } else {
                      vacationIsOn = false;
                    }
                  }

                  if (widget.product != null &&
                      widget.product!.seller != null &&
                      widget.product!.seller!.shop!.temporaryClose!) {
                    temporaryClose = true;
                  } else {
                    temporaryClose = false;
                  }
                }

                if (widget.product != null) {
                  if (vacationIsOn || temporaryClose) {
                    showCustomSnackBar(
                        getTranslated('this_shop_is_close_now', context),
                        context,
                        isToaster: true);
                  } else {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor:
                            Theme.of(context).primaryColor.withOpacity(0),
                        builder: (con) => CartBottomSheet(
                              product: widget.product,
                              callback: () {
                                showCustomSnackBar(
                                    getTranslated('added_to_cart', context),
                                    context,
                                    isError: false);
                              },
                            ));
                  }
                }
              },
              child: Container(
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                ),
                child: Text(
                  getTranslated('add_to_cart', context)!,
                  style: titilliumSemiBold.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: Provider.of<ThemeProvider>(context, listen: false)
                              .darkTheme
                          ? Theme.of(context).hintColor
                          : Theme.of(context).highlightColor),
                ),
              ),
            )),
      ]),
    );
  }
}
