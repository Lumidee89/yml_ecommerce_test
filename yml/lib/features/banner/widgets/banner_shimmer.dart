import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/utill/color_resources.dart';
import 'package:shimmer/shimmer.dart';

class BannerShimmer extends StatelessWidget {
  const BannerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      enabled: true,
      child: Container(margin: const EdgeInsets.symmetric(horizontal: 10), decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorResources.white,
      )),
    );
  }
}
