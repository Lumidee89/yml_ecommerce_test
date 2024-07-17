import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/features/category/controllers/category_controller.dart';
import 'package:yml_ecommerce_test/features/category/widget/category_widget.dart';
import 'package:yml_ecommerce_test/features/product/view/brand_and_category_product_screen.dart';
import 'package:provider/provider.dart';

import 'category_shimmer.dart';

class CategoryView extends StatelessWidget {
  final bool isHomePage;
  const CategoryView({super.key, required this.isHomePage});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryController>(
      builder: (context, categoryProvider, child) {

        return categoryProvider.categoryList != null? categoryProvider.categoryList!.isNotEmpty ?
        SizedBox( height: 120,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            itemCount: categoryProvider.categoryList?.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => BrandAndCategoryProductScreen(
                    isBrand: false,
                    id: categoryProvider.categoryList![index].id.toString(),
                    name: categoryProvider.categoryList![index].name,
                  )));
                },
                child: CategoryWidget(category: categoryProvider.categoryList![index],
                    index: index,length:  categoryProvider.categoryList!.length),
              );

            },
          ),
        ) : const SizedBox() : const CategoryShimmer();

      },
    );
  }
}



