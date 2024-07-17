import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/features/product/domain/model/product_model.dart';

import 'package:yml_ecommerce_test/helper/price_converter.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/features/splash/provider/splash_provider.dart';
import 'package:yml_ecommerce_test/theme/provider/theme_provider.dart';
import 'package:yml_ecommerce_test/utill/color_resources.dart';
import 'package:yml_ecommerce_test/utill/custom_themes.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/basewidget/custom_image.dart';
import 'package:yml_ecommerce_test/features/product/view/product_details_screen.dart';
import 'package:yml_ecommerce_test/features/product/widget/favourite_button.dart';
import 'package:provider/provider.dart';

import '../features/product/widget/bottom_cart_view.dart';

class ProductWidget extends StatelessWidget {
  final Product productModel;
  const ProductWidget({super.key, required this.productModel});

  @override
  Widget build(BuildContext context) {
    String ratting =
        productModel.rating != null && productModel.rating!.isNotEmpty
            ? productModel.rating![0].average!
            : "0";

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 1000),
                pageBuilder: (context, anim1, anim2) => ProductDetails(
                    productId: productModel.id, slug: productModel.slug)));
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).highlightColor,
          boxShadow:
              Provider.of<ThemeProvider>(context, listen: false).darkTheme
                  ? null
                  : [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5)
                    ],
        ),
        child: Stack(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Container(
                height: 140,
                decoration: BoxDecoration(
                  color: Provider.of<ThemeProvider>(context, listen: false)
                          .darkTheme
                      ? Theme.of(context).primaryColor.withOpacity(.05)
                      : ColorResources.getIconBg(context),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    child: CustomImage(
                      image:
                          '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productThumbnailUrl}/${productModel.thumbnail}',
                      height: MediaQuery.of(context).size.width / 2.45,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.contain,
                    ))),

            // Product Details
            Padding(
              padding: const EdgeInsets.only(
                  top: Dimensions.paddingSizeSmall,
                  bottom: 5,
                  left: 5,
                  right: 5),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (productModel.currentStock! <
                            productModel.minimumOrderQuantity! &&
                        productModel.productType == 'physical')
                      Padding(
                          padding: const EdgeInsets.only(
                              bottom: Dimensions.paddingSizeExtraSmall),
                          child: Text(
                              getTranslated('out_of_stock', context) ?? '',
                              style: textRegular.copyWith(
                                  color: const Color(0xFFF36A6A)))),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Icon(Icons.star_rate_rounded,
                          color: Colors.orange, size: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Text(double.parse(ratting).toStringAsFixed(1),
                            style: textRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault)),
                      ),
                      Text('(${productModel.reviewCount.toString()})',
                          style: textRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).hintColor))
                    ]),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Text(productModel.name ?? '',
                            textAlign: TextAlign.center,
                            style: textRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                fontWeight: FontWeight.w400),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis)),
                    productModel.discount != null && productModel.discount! > 0
                        ? Text(
                            PriceConverter.convertPrice(
                                context, productModel.unitPrice),
                            style: titleRegular.copyWith(
                                color: Theme.of(context).hintColor,
                                decoration: TextDecoration.lineThrough,
                                fontSize: Dimensions.fontSizeSmall))
                        : const SizedBox.shrink(),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                        PriceConverter.convertPrice(
                            context, productModel.unitPrice,
                            discountType: productModel.discountType,
                            discount: productModel.discount),
                        style: titilliumSemiBold.copyWith(
                            color: ColorResources.getPrimary(context))),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: BottomCartView(
                          productId: productModel.id,
                          productSlug: productModel.slug),
                    )
                  ],
                ),
              ),
            ),
          ]),

          // Off

          productModel.discount! > 0
              ? Positioned(
                  top: 10,
                  left: 0,
                  child: Container(
                    height: 20,
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      color: ColorResources.getPrimary(context),
                      borderRadius: const BorderRadius.only(
                          topRight:
                              Radius.circular(Dimensions.paddingSizeExtraSmall),
                          bottomRight: Radius.circular(
                              Dimensions.paddingSizeExtraSmall)),
                    ),
                    child: Center(
                      child: Text(
                          PriceConverter.percentageCalculation(
                              context,
                              productModel.unitPrice,
                              productModel.discount,
                              productModel.discountType),
                          style: textRegular.copyWith(
                              color: Theme.of(context).highlightColor,
                              fontSize: Dimensions.fontSizeSmall)),
                    ),
                  ),
                )
              : const SizedBox.shrink(),

          Positioned(
            top: 5,
            right: 5,
            child: FavouriteButton(
              backgroundColor: ColorResources.getImageBg(context),
              productId: productModel.id,
            ),
          ),
        ]),
      ),
    );
  }
}
