import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/features/brand/domain/models/brand_model.dart';
import 'package:yml_ecommerce_test/features/category/domain/model/category_model.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/features/brand/controllers/brand_controller.dart';
import 'package:yml_ecommerce_test/features/category/controllers/category_controller.dart';
import 'package:yml_ecommerce_test/features/product/provider/search_provider.dart';
import 'package:yml_ecommerce_test/theme/provider/theme_provider.dart';
import 'package:yml_ecommerce_test/utill/app_constants.dart';
import 'package:yml_ecommerce_test/utill/custom_themes.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/basewidget/custom_button.dart';
import 'package:provider/provider.dart';

class SearchFilterBottomSheet extends StatefulWidget {
  const SearchFilterBottomSheet({super.key});

  @override
  SearchFilterBottomSheetState createState() => SearchFilterBottomSheetState();
}

class SearchFilterBottomSheetState extends State<SearchFilterBottomSheet> {
  RangeValues currentRangeValues = const RangeValues(AppConstants.minFilter, AppConstants.maxFilter,);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Consumer<SearchProvider>(
          builder: (context, searchProvider, child) {
            return Consumer<CategoryController>(
              builder: (context, categoryProvider,_) {
                return Consumer<BrandController>(
                  builder: (context, brandProvider,_) {
                    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [

                        Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                          child: Center(child: Container(width: 35,height: 4,decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                            color: Theme.of(context).hintColor.withOpacity(.5))))),

                        Text(getTranslated('price', context)??'',
                          style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

                        Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                          child: RangeSlider(
                            values: currentRangeValues,
                            max: AppConstants.maxFilter,
                            divisions: 1000,
                            labels: RangeLabels(
                              currentRangeValues.start.round().toString(),
                              currentRangeValues.end.round().toString(),
                            ),
                            onChanged: (RangeValues values) {

                              setState(() {
                                currentRangeValues = values;
                              });
                            },
                          ),
                        ),




                        Text(getTranslated('sort', context)??'',
                          style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

                        FilterItemWidget(title: getTranslated('latest_products', context), index: 0),
                        FilterItemWidget(title: getTranslated('alphabetically_az', context), index: 1),
                        FilterItemWidget(title: getTranslated('alphabetically_za', context), index: 2),
                        FilterItemWidget(title: getTranslated('low_to_high_price', context), index: 3),
                        FilterItemWidget(title: getTranslated('high_to_low_price', context), index: 4),



                        Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: Row(children: [
                              Padding(padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                child: SizedBox(width: 120,
                                    child: CustomButton(backgroundColor: Theme.of(context).colorScheme.tertiaryContainer.withOpacity(.5),
                                        textColor: Provider.of<ThemeProvider>(context, listen: false).darkTheme? Colors.white : Theme.of(context).primaryColor,
                                        radius: 8,
                                        buttonText: getTranslated('clear', context),
                                        onTap: () {

                                      Provider.of<SearchProvider>(context, listen: false).setFilterIndex(0);
                                      Navigator.of(context).pop();
                                    }
                                    )),
                              ),

                              Expanded(
                                child: CustomButton(
                                  radius: 8,
                                  buttonText: getTranslated('apply', context),
                                  onTap: () {
                                    List<int> selectedBrandIdsList =[];
                                    List<int> selectedCategoryIdsList =[];

                                    for(CategoryModel category in categoryProvider.categoryList!){
                                      if(category.isSelected!){
                                        selectedCategoryIdsList.add(category.id!);
                                      }
                                    }
                                    for(CategoryModel category in categoryProvider.categoryList!){
                                      if(category.isSelected!){
                                        if(category.subCategories != null){
                                          for(int i=0; i< category.subCategories!.length; i++){
                                            selectedCategoryIdsList.add(category.subCategories![i].id!);
                                          }
                                        }

                                      }
                                    }
                                    for(BrandModel brand in brandProvider.brandList!){
                                      if(brand.checked!){
                                        selectedBrandIdsList.add(brand.id!);
                                      }
                                    }

                                    String selectedCategoryId = selectedCategoryIdsList.isNotEmpty? jsonEncode(selectedCategoryIdsList) : '[]';
                                    String selectedBrandId = selectedBrandIdsList.isNotEmpty? jsonEncode(selectedBrandIdsList) : '[]';
                                    searchProvider.searchProduct(query : searchProvider.searchController.text.toString(),
                                        offset: 1, brandIds: selectedBrandId, categoryIds: selectedCategoryId, sort: searchProvider.sortText,
                                        priceMin: currentRangeValues.start.toString(), priceMax: currentRangeValues.end.toString());
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                );
              }
            );
          }
        ),

      ]),
    );
  }
}

class FilterItemWidget extends StatelessWidget {
  final String? title;
  final int index;
  const FilterItemWidget({super.key, required this.title, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
      child: Container(decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
        border: Border.all(width: 1, color: Theme.of(context).hintColor.withOpacity(.1))),
        child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Row(children: [
            Expanded(child: Text(title??'', style: textRegular.copyWith())),
            InkWell(onTap: ()=> Provider.of<SearchProvider>(context, listen: false).setFilterIndex(index),
                child: Icon(Provider.of<SearchProvider>(context).filterIndex == index? Icons.radio_button_checked: Icons.radio_button_off,
                    color: Provider.of<SearchProvider>(context).filterIndex == index? Theme.of(context).primaryColor: Theme.of(context).hintColor.withOpacity(.15)))
      ],)),),
    );
  }
}

