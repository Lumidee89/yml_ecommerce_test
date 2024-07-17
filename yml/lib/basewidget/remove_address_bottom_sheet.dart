import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/features/address/controllers/address_controller.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/utill/custom_themes.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/utill/images.dart';
import 'package:yml_ecommerce_test/basewidget/custom_button.dart';
import 'package:provider/provider.dart';

class RemoveFromAddressBottomSheet extends StatelessWidget {
  final int addressId;
  final int index;
  const RemoveFromAddressBottomSheet({super.key, required this.addressId, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.only(bottom: 40, top: 15),
      decoration: BoxDecoration(color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.paddingSizeDefault))),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 40,height: 5,decoration: BoxDecoration(color: Theme.of(context).hintColor.withOpacity(.5),
            borderRadius: BorderRadius.circular(20)),),
        const SizedBox(height: 40,),

        Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
          child: SizedBox(width: 60,child: Image.asset(Images.removeAddress)),),

        const SizedBox(height: Dimensions.paddingSizeDefault,),
        Text(getTranslated('remove_this_address', context)!, style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge),),

        Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeLarge),
          child: Text('${getTranslated('address_will_remove', context)}'),),

        const SizedBox(height: Dimensions.paddingSizeSmall),

        Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeOverLarge),
          child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            SizedBox(width: 120,child: CustomButton(buttonText: '${getTranslated('cancel', context)}',
              backgroundColor: Theme.of(context).colorScheme.tertiaryContainer.withOpacity(.5),
              textColor: Theme.of(context).textTheme.bodyLarge?.color,
              onTap: ()=> Navigator.pop(context),)),
            const SizedBox(width: Dimensions.paddingSizeDefault,),
            SizedBox(width: 120,child: CustomButton(buttonText: '${getTranslated('remove', context)}',
                backgroundColor: Theme.of(context).colorScheme.error,
                onTap: (){
                  Provider.of<AddressController>(context, listen: false).removeAddressById(addressId, index, context);
                  Navigator.of(context).pop();
                }))
          ],),
        )

      ],),
    );
  }
}
