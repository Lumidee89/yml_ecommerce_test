import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/theme/provider/theme_provider.dart';
import 'package:yml_ecommerce_test/features/shop/provider/top_seller_provider.dart';
import 'package:yml_ecommerce_test/utill/color_resources.dart';
import 'package:yml_ecommerce_test/features/shop/widget/seller_card.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';



class TopSellerView extends StatelessWidget {
  final bool isHomePage;
  const TopSellerView({super.key, required this.isHomePage});

  @override
  Widget build(BuildContext context) {

    return Consumer<TopSellerProvider>(
      builder: (context, topSellerProvider, child) {


        return topSellerProvider.topSellerList != null? topSellerProvider.topSellerList!.isNotEmpty ?
            ListView.builder(
              itemCount: topSellerProvider.topSellerList!.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              scrollDirection: isHomePage? Axis.horizontal : Axis.vertical,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(width: 250,
                    child: SellerCard(sellerModel: topSellerProvider.topSellerList![index], isHomePage: isHomePage,
                        index: index,length: topSellerProvider.topSellerList!.length));
              },
            ) : const SizedBox():const TopSellerShimmer();

      },
    );
  }
}

class TopSellerShimmer extends StatelessWidget {
  const TopSellerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: (1/1)),
      itemCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {

        return Container(
          decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 200]!, spreadRadius: 2, blurRadius: 5)]),
          margin: const EdgeInsets.all(3),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [

            Expanded(
              flex: 7,
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                enabled: ( Provider.of<TopSellerProvider>(context).topSellerList == null),
                child: Container(decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                )),
              ),
            ),

            Expanded(flex: 3, child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ColorResources.getTextBg(context),
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
              ),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                enabled: true,
                child: Container(height: 10, color: Colors.white, margin: const EdgeInsets.only(left: 15, right: 15)),
              ),
            )),

          ]),
        );

      },
    );
  }
}

