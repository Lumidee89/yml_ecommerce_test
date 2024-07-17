import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/utill/color_resources.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:shimmer/shimmer.dart';

class ProductShimmer extends StatelessWidget {
  final bool isEnabled;
  final bool isHomePage;
  const ProductShimmer({super.key, required this.isEnabled, required this.isHomePage});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
      child: GridView.builder(

        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        crossAxisSpacing: 10,mainAxisSpacing: 10,
        childAspectRatio: (1 / 1.5),),
        itemCount: 10,
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).highlightColor),
            child: Shimmer.fromColors(
              baseColor: Theme.of(context).cardColor,
              highlightColor: Colors.grey[300]!,
              enabled: true,
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Expanded(
                  flex: 6,
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorResources.iconBg(),
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    ),
                  ),
                ),

                // Product Details
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 20, color: Colors.white),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                        Row(children: [
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Container(height: 20, width: 50, color: Colors.white),
                            ]),
                          ),
                          Container(height: 10, width: 50, color: Colors.white),
                          const Icon(Icons.star, color: Colors.orange, size: 15),
                        ]),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          );
        },
      ),
    );
  }
}
