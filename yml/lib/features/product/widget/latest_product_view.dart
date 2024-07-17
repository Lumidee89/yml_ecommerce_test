
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/features/product/domain/model/product_model.dart';

import 'package:yml_ecommerce_test/helper/product_type.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/localization/provider/localization_provider.dart';
import 'package:yml_ecommerce_test/features/product/provider/product_provider.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/basewidget/title_row.dart';
import 'package:yml_ecommerce_test/features/home/shimmer/latest_product_shimmer.dart';
import 'package:yml_ecommerce_test/features/product/widget/latest_product_widget.dart';
import 'package:yml_ecommerce_test/features/product/view/view_all_product_screen.dart';
import 'package:provider/provider.dart';


class LatestProductView extends StatelessWidget {
  const LatestProductView({super.key});

  @override
  Widget build(BuildContext context) {

    return Consumer<ProductProvider>(
      builder: (context, prodProvider, child) {
        List<Product>? productList;
        productList = prodProvider.lProductList;

        return productList != null? productList.isNotEmpty ?
          Column(children: [
              TitleRow(title: getTranslated('latest_products', context),
                  onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_) => AllProductScreen(productType: ProductType.latestProduct)))),

              const SizedBox(height: Dimensions.paddingSizeSmall),
              SizedBox(height: 410,
                child: Padding(padding: EdgeInsets.only(left: Provider.of<LocalizationProvider>(context, listen: false).isLtr? Dimensions.paddingSizeDefault:0,
                    right: Provider.of<LocalizationProvider>(context, listen: false).isLtr? 0 : Dimensions.paddingSizeDefault,
                    bottom: Dimensions.paddingSizeDefault),
                  child: Swiper(
                    autoplay: true,
                    layout: SwiperLayout.STACK,

                    itemWidth: MediaQuery.of(context).size.width-50,
                    itemHeight: 400.0,
                    itemBuilder: (BuildContext context,int index){
                      return LatestProductWidget(productModel :productList![index] );
                    },
                    itemCount: productList.length,

                  ),
                ),
              ),
            ],
          ): const SizedBox.shrink() : const LatestProductShimmer();
      },
    );
  }
}

