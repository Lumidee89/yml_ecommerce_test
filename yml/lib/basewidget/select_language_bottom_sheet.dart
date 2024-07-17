import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/features/category/controllers/category_controller.dart';
import 'package:yml_ecommerce_test/localization/provider/localization_provider.dart';
import 'package:yml_ecommerce_test/utill/app_constants.dart';
import 'package:yml_ecommerce_test/utill/custom_themes.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/basewidget/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:yml_ecommerce_test/features/brand/controllers/brand_controller.dart';
import 'package:yml_ecommerce_test/features/deal/provider/featured_deal_provider.dart';
import 'package:yml_ecommerce_test/features/product/provider/home_category_product_provider.dart';
import 'package:yml_ecommerce_test/features/product/provider/product_provider.dart';
import 'package:yml_ecommerce_test/features/shop/provider/top_seller_provider.dart';

class SelectLanguageBottomSheet extends StatefulWidget {
  const SelectLanguageBottomSheet({super.key});

  @override
  State<SelectLanguageBottomSheet> createState() => _SelectLanguageBottomSheetState();
}

class _SelectLanguageBottomSheetState extends State<SelectLanguageBottomSheet> {
  int selectedIndex = 0;
  @override
  void initState() {
    selectedIndex = Provider.of<LocalizationProvider>(context, listen: false).languageIndex!;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationProvider>(
      builder: (context, localizationProvider, _) {
        return SingleChildScrollView(
          child: Container(padding: const EdgeInsets.only(bottom: 40, top: 15),
            decoration: BoxDecoration(color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.paddingSizeDefault))),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 40,height: 5,decoration: BoxDecoration(color: Theme.of(context).hintColor.withOpacity(.5),
                  borderRadius: BorderRadius.circular(20))),
              const SizedBox(height: 40,),

              Text(getTranslated('select_language', context)!, style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge),),
              Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeLarge),
                child: Text('${getTranslated('choose_your_language_to_proceed', context)}'),),

              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: AppConstants.languages.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                  return InkWell(
                    onTap: (){
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, 0,Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall),
                      child: Container(decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                        color: selectedIndex == index? Theme.of(context).primaryColor.withOpacity(.1): Theme.of(context).cardColor),
                        child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                          child: Row(children: [
                          SizedBox(width: 25, child: Image.asset(AppConstants.languages[index].imageUrl!)),

                            Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                              child: Text(AppConstants.languages[index].languageName!))
                          ])))),
                  );

              }),

              Padding(padding: const EdgeInsets.fromLTRB( Dimensions.paddingSizeSmall, Dimensions.paddingSizeSmall, Dimensions.paddingSizeSmall,0),
                child: CustomButton(buttonText: '${getTranslated('select', context)}', onTap: (){
                  Provider.of<LocalizationProvider>(context, listen: false).setLanguage(Locale(
                    AppConstants.languages[selectedIndex].languageCode!,
                    AppConstants.languages[selectedIndex].countryCode));
                  Provider.of<CategoryController>(context, listen: false).getCategoryList(true);
                  Provider.of<HomeCategoryProductProvider>(context, listen: false).getHomeCategoryProductList(true);
                  Provider.of<TopSellerProvider>(context, listen: false).getTopSellerList(true);
                  Provider.of<BrandController>(context, listen: false).getBrandList(true);
                  Provider.of<ProductProvider>(context, listen: false).getLatestProductList(1, reload: true);
                  Provider.of<ProductProvider>(context, listen: false).getFeaturedProductList('1', reload: true);
                  Provider.of<FeaturedDealProvider>(context, listen: false).getFeaturedDealList(true);
                  Provider.of<ProductProvider>(context, listen: false).getLProductList('1', reload: true);
                  Navigator.pop(context);},))

            ],),
          ),
        );
      }
    );
  }
}
