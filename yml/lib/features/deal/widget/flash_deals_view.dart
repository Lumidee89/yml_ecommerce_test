import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/helper/price_converter.dart';
import 'package:yml_ecommerce_test/features/deal/provider/flash_deal_provider.dart';
import 'package:yml_ecommerce_test/features/splash/provider/splash_provider.dart';
import 'package:yml_ecommerce_test/theme/provider/theme_provider.dart';
import 'package:yml_ecommerce_test/utill/color_resources.dart';
import 'package:yml_ecommerce_test/utill/custom_themes.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/basewidget/custom_image.dart';
import 'package:yml_ecommerce_test/basewidget/custom_slider/carousel_options.dart';
import 'package:yml_ecommerce_test/basewidget/custom_slider/custom_slider.dart';
import 'package:yml_ecommerce_test/features/deal/widget/flash_deal_card.dart';
import 'package:yml_ecommerce_test/features/home/shimmer/flash_deal_shimmer.dart';
import 'package:yml_ecommerce_test/features/product/view/product_details_screen.dart';
import 'package:yml_ecommerce_test/features/product/widget/favourite_button.dart';
import 'package:provider/provider.dart';


class FlashDealsView extends StatelessWidget {
  final bool isHomeScreen;
  const FlashDealsView({super.key, this.isHomeScreen = true});

  @override
  Widget build(BuildContext context) {

    return isHomeScreen?
    Consumer<FlashDealProvider>(
      builder: (context, megaProvider, child) {
        return megaProvider.flashDeal != null ? megaProvider.flashDealList.isNotEmpty ?
        CarouselSlider.builder(
          options: CarouselOptions(
            viewportFraction: .7,
            autoPlay: true,
            enlargeFactor: 0.4,
            enlargeCenterPage: true,
            disableCenter: true,
            onPageChanged: (index, reason) {
              Provider.of<FlashDealProvider>(context, listen: false).setCurrentIndex(index);
            },
          ),
          itemCount: megaProvider.flashDealList.isEmpty ? 1 : megaProvider.flashDealList.length,
          itemBuilder: (context, index, _) {

            return FlashDealCard(product: megaProvider.flashDealList[index],megaProvider: megaProvider, index: index);
          },
        ) : const SizedBox() : const FlashDealShimmer();
      },
    ):
    Consumer<FlashDealProvider>(
      builder: (context, megaProvider, child) {
        return Provider.of<FlashDealProvider>(context).flashDealList.isNotEmpty ?
        ListView.builder(
          padding: const EdgeInsets.all(0),
          scrollDirection:  Axis.vertical,
          itemCount: megaProvider.flashDealList.length,
          itemBuilder: (context, index) {

            return InkWell(
              onTap: () {
                Navigator.push(context, PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 1000),
                  pageBuilder: (context, anim1, anim2) => ProductDetails(productId: megaProvider.flashDealList[index].id, slug: megaProvider.flashDealList[index].slug,),
                ));
              },
              child: Container(
                margin: const EdgeInsets.all(5),
                width: isHomeScreen ? 300 : null,
                height: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).highlightColor,
                    boxShadow: Provider.of<ThemeProvider>(context, listen: false).darkTheme?null : [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 5)]),
                child: Stack(children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [

                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                          color: ColorResources.getIconBg(context),
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                        ),
                        child: CustomImage(image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productThumbnailUrl}'
                            '/${megaProvider.flashDealList[index].thumbnail}')
                      ),
                    ),

                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Row(children: [
                                Expanded(child: Text(megaProvider.flashDealList[index].name!,
                                    style: textRegular,
                                    maxLines: 2, overflow: TextOverflow.ellipsis,),
                                ),
                              const SizedBox(width: 50,)
                              ],
                            ),

                            const SizedBox(height: Dimensions.paddingSizeDefault,),


                            Row(children: [
                              Text(megaProvider.flashDealList[index].rating!.isNotEmpty ?
                                double.parse(megaProvider.flashDealList[index].rating![0].average!).toStringAsFixed(1) : '0.0',
                                style: textRegular.copyWith( fontSize: Dimensions.fontSizeSmall),
                              ),
                              Icon(Icons.star, color: Provider.of<ThemeProvider>(context).darkTheme ?
                              Colors.white : Colors.orange, size: 15),

                              Text('(${megaProvider.flashDealList[index].reviewCount.toString()})',
                                  style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall,)),
                            ]),
                            const SizedBox(height: Dimensions.paddingSizeDefault,),


                            Row(children: [
                                Text(megaProvider.flashDealList[index].discount! > 0 ?
                                  PriceConverter.convertPrice(context, megaProvider.flashDealList[index].unitPrice) : '',
                                  style: textRegular.copyWith(
                                    color: ColorResources.getRed(context),
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: Dimensions.fontSizeSmall,
                                  ),
                                ),
                                const SizedBox(width: Dimensions.paddingSizeDefault,),


                                Text(PriceConverter.convertPrice(context, megaProvider.flashDealList[index].unitPrice,
                                      discountType: megaProvider.flashDealList[index].discountType, discount: megaProvider.flashDealList[index].discount),
                                  style: titleRegular.copyWith(color: ColorResources.getPrimary(context), fontSize: Dimensions.fontSizeLarge),
                                ),
                              ],
                            ),
                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                          ],
                        ),
                      ),
                    ),
                  ]),

                  // Off
                  megaProvider.flashDealList[index].discount! >= 1 ?
                  Positioned(top: 15, left: 10,
                    child: Container(height: 20, alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: ColorResources.getPrimary(context),
                        borderRadius: const BorderRadius.horizontal(right: Radius.circular(5)),
                      ),


                      child: Padding(padding:  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                        child: Text(PriceConverter.percentageCalculation(
                          context,
                          megaProvider.flashDealList[index].unitPrice,
                          megaProvider.flashDealList[index].discount,
                          megaProvider.flashDealList[index].discountType,),
                          style: textRegular.copyWith(color: Theme.of(context).highlightColor,
                              fontSize: Dimensions.fontSizeSmall),
                        ),
                      ),
                    ),
                  ) : const SizedBox.shrink(),

                  Positioned(top: 10, right: 15, child: FavouriteButton(
                    backgroundColor: ColorResources.getImageBg(context),
                    productId: megaProvider.flashDealList[index].id,
                  )),
                ]),
              ),
            );
          },
        ) : const FlashDealShimmer();
      },
    );
  }
}



