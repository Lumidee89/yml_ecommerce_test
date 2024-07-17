import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/features/product/provider/product_details_provider.dart';
import 'package:yml_ecommerce_test/theme/provider/theme_provider.dart';
import 'package:yml_ecommerce_test/utill/color_resources.dart';
import 'package:yml_ecommerce_test/utill/custom_themes.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/basewidget/rating_bar.dart';
import 'package:yml_ecommerce_test/features/product/view/faq_and_review_screen.dart';
import 'package:yml_ecommerce_test/features/product/widget/review_widget.dart';
import 'package:provider/provider.dart';

class ReviewSection extends StatelessWidget {
  final ProductDetailsProvider details;
  const ReviewSection({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Container(width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      color:  Theme.of(context).cardColor,
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text(getTranslated('customer_reviews', context)!,
          style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),),
        const SizedBox(height: Dimensions.paddingSizeDefault,),
        Container(width: 230,height: 30,
          decoration: BoxDecoration(color: ColorResources.visitShop(context),
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraLarge),),


          child: Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center, children: [
              RatingBar(rating: double.parse(details.productDetailsModel!.averageReview!), size: 18,),
              const SizedBox(width: Dimensions.paddingSizeDefault),
              Text('${double.parse(details.productDetailsModel!.averageReview!).toStringAsFixed(1)} ${getTranslated('out_of_5', context)}',
                  style: textRegular.copyWith(color: Provider.of<ThemeProvider>(context, listen: false).darkTheme? Theme.of(context).hintColor : Colors.black)),
            ],
          ),
        ),

        const SizedBox(height: Dimensions.paddingSizeDefault),
        Text('${getTranslated('total', context)} ${details.reviewList != null ? details.reviewList!.length : 0} ${getTranslated('reviews', context)}'),



        details.reviewList != null ? details.reviewList!.isNotEmpty ? ReviewWidget(reviewModel: details.reviewList![0])
            : const SizedBox() : const ReviewShimmer(),
        details.reviewList != null ? details.reviewList!.length > 1 ? ReviewWidget(reviewModel: details.reviewList![1])
            : const SizedBox() : const ReviewShimmer(),
        details.reviewList != null ? details.reviewList!.length > 2 ? ReviewWidget(reviewModel: details.reviewList![2])
            : const SizedBox() : const ReviewShimmer(),

        InkWell(onTap: () {
          if(details.reviewList != null)
          {Navigator.push(context, MaterialPageRoute(builder: (_) =>
              ReviewScreen(reviewList: details.reviewList)));}},
            child: details.reviewList != null && details.reviewList!.length > 3?
            Text(getTranslated('view_more', context)!, style: titilliumRegular.copyWith(color: Theme.of(context).primaryColor),):const SizedBox())
      ]),
    );
  }
}
