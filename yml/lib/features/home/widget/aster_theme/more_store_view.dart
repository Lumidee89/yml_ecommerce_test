import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/features/shop/provider/shop_provider.dart';
import 'package:yml_ecommerce_test/features/home/widget/aster_theme/more_store_widget.dart';
import 'package:provider/provider.dart';

class MoreStoreView extends StatefulWidget {
  final bool isHome;
  const MoreStoreView({super.key,  this.isHome = false});

  @override
  State<MoreStoreView> createState() => _MoreStoreViewState();
}

class _MoreStoreViewState extends State<MoreStoreView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SellerProvider>(
      builder: (context, moreSellerProvider, _) {
        return ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: moreSellerProvider.moreStoreList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return SizedBox(width: 95,child: MoreStoreWidget(moreStore: moreSellerProvider.moreStoreList[index], index: index, length: moreSellerProvider.moreStoreList.length));
          },
        );
      }
    );
  }
}
