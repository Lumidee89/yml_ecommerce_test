import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/features/product/provider/product_provider.dart';
import 'package:yml_ecommerce_test/features/home/widget/shop_again_from_recent_store_card.dart';
import 'package:provider/provider.dart';

class ShopAgainFromYourRecentStore extends StatelessWidget {

  const ShopAgainFromYourRecentStore({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, shopAgainProvider,_) {
        return ListView.builder(
          shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: shopAgainProvider.shopAgainFromRecentStoreList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
          return ShopAgainFromRecentStoreCard(shopAgainFromRecentStoreModel: shopAgainProvider.shopAgainFromRecentStoreList[index], index: index,length: shopAgainProvider.shopAgainFromRecentStoreList.length,);
        });
      }
    );
  }
}
