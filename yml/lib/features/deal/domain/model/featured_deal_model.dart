
import 'package:yml_ecommerce_test/features/product/domain/model/product_model.dart';


class FeaturedDealModel {

  Product? product;

  FeaturedDealModel(
      {this.product});

  FeaturedDealModel.fromJson(Map<String, dynamic> json) {

    product = json['product'] != null ? Product.fromJson(json['product']) : null;
  }

}


