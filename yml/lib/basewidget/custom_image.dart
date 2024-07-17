import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/utill/images.dart';

class CustomImage extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final String? placeholder;
  const CustomImage({super.key, required this.image, this.height, this.width, this.fit = BoxFit.cover, this.placeholder = Images.placeholder});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(

      placeholder: (context, url) => Image.asset(placeholder?? Images.placeholder, height: height, width: width, fit: BoxFit.cover),
      imageUrl: image, fit: fit?? BoxFit.cover,
      height: height,width: width,
      errorWidget: (c, o, s) => Image.asset(placeholder?? Images.placeholder, height: height, width: width, fit: BoxFit.cover),
    );
  }
}
