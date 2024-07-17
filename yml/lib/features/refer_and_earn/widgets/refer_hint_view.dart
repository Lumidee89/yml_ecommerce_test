

import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/utill/custom_themes.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/utill/images.dart';

class ReferHintView extends StatelessWidget {
  final List<String> hintList;
  const ReferHintView({super.key, required this.hintList});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        child: Container(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.2), width: 2),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20))),
          child: Column(children: [
            Container(decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(15)),
              height: Dimensions.paddingSizeExtraSmall , width: 30),
            const SizedBox(height: Dimensions.paddingSizeDefault,),

            Row(children: [
              Image.asset(Images.iMark, height: Dimensions.paddingSizeLarge,),
              const SizedBox(width: Dimensions.paddingSizeSmall,),

              Text('${getTranslated('how_it_works', context)}',
                style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).textTheme.bodyLarge!.color),)],),
            const SizedBox(height: Dimensions.paddingSizeSmall,),

            Column(children: hintList.map((hint) => Row(children: [
                Container(margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 3))]),
                  child: Text('${hintList.indexOf(hint) + 1}',style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge,))),
                const SizedBox(width: Dimensions.paddingSizeSmall,),

                Flexible(child: Text(hint, style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge))),
              ],
            ),).toList(),)
          ],),
        ),
      ),
    );
  }
}
