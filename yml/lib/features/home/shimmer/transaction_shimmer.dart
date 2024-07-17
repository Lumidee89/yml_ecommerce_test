import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/utill/color_resources.dart';
import 'package:shimmer/shimmer.dart';

class TransactionShimmer extends StatelessWidget {
  const TransactionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      shrinkWrap: true,
      reverse: true,
      itemBuilder: (context, index) {

        return Shimmer.fromColors(baseColor: Theme.of(context).cardColor,
          highlightColor: Colors.grey[300]!,
          enabled: true,
          child: Row( children: [
             const InkWell(child: CircleAvatar(child: Icon(Icons.person))),
            Expanded(child: Container(margin:  const EdgeInsets.fromLTRB(10, 5, 50, 5),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration:  BoxDecoration(color:  ColorResources.iconBg()),
              child: Container(height: 20)))]),
        );
      },
    );
  }
}