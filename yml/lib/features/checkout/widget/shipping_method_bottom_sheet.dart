import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/features/cart/domain/models/shipping_method_model.dart';
import 'package:yml_ecommerce_test/helper/price_converter.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/features/cart/controllers/cart_controller.dart';
import 'package:yml_ecommerce_test/utill/custom_themes.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/basewidget/custom_button.dart';
import 'package:provider/provider.dart';

class ShippingMethodBottomSheet extends StatefulWidget {
  final String? groupId;
  final int? sellerId;
  final int sellerIndex;
  const ShippingMethodBottomSheet({super.key, required this.groupId, required this.sellerId, required this.sellerIndex});

  @override
  ShippingMethodBottomSheetState createState() => ShippingMethodBottomSheetState();
}

class ShippingMethodBottomSheetState extends State<ShippingMethodBottomSheet> {
  int selectedIndex = 0;
  @override
  void initState() {
    if(Provider.of<CartController>(context, listen: false).shippingList != null && Provider.of<CartController>(context, listen: false).shippingList!.isNotEmpty){
      selectedIndex = Provider.of<CartController>(context, listen: false).shippingList![widget.sellerIndex].shippingIndex??0;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: Container(padding: const EdgeInsets.symmetric(vertical:Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(color: Theme.of(context).highlightColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.paddingSizeDefault), ),),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            InkWell(onTap: () => Navigator.pop(context),
              child: Container(width: 40,height: 5,decoration: BoxDecoration(
                  color: Theme.of(context).hintColor.withOpacity(.5),
                  borderRadius: BorderRadius.circular(20)
              ),),
            ),
            const SizedBox(height: 20,),
            Text(getTranslated('select_shipping_method', context)!, style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge),),

            Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeLarge),
              child: Text('${getTranslated('choose_a_method_for_your_delivery', context)}'),),


            Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Consumer<CartController>(
                builder: (context, order, child) {
                  return (order.shippingList != null && order.shippingList!.isNotEmpty && order.shippingList![widget.sellerIndex].shippingMethodList != null) ? ( order.shippingList![widget.sellerIndex].shippingMethodList!.isNotEmpty) ?  SizedBox(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: order.shippingList![widget.sellerIndex].shippingMethodList!.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {

                            return Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                              child: Container(decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                border: Border.all(color: Theme.of(context).primaryColor.withOpacity(.25),width: .5),
                                color: selectedIndex == index? Theme.of(context).primaryColor.withOpacity(.1): Theme.of(context).cardColor
                              ),
                                child: InkWell(
                                  onTap: (){
                                    setState(() {
                                      selectedIndex = index;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(children: [
                                      selectedIndex == index?
                                      const Icon(Icons.check_circle, color: Colors.green,): Icon(Icons.circle_outlined, color: Theme.of(context).hintColor,),
                                      const SizedBox(width: Dimensions.paddingSizeSmall),
                                      Expanded(
                                        child: Text('${order.shippingList![widget.sellerIndex].shippingMethodList![index].title} (Duration ${order.shippingList![widget.sellerIndex].shippingMethodList![index].duration})'),),
                                      const SizedBox(width: Dimensions.paddingSizeSmall),

                                      Text(' ${PriceConverter.convertPrice(context, order.shippingList![widget.sellerIndex].shippingMethodList![index].cost)}',
                                        style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge),)
                                    ],),
                                  ),
                                )

                              ),
                            );
                          },
                        ),

                      const SizedBox(height: Dimensions.paddingSizeDefault,),
                      CustomButton(buttonText: '${getTranslated('select', context)}', onTap: (){
                        Provider.of<CartController>(context, listen: false).setSelectedShippingMethod(selectedIndex, widget.sellerIndex);
                        ShippingMethodModel shipping = ShippingMethodModel();
                        shipping.id = order.shippingList![widget.sellerIndex].shippingMethodList![selectedIndex].id;
                        shipping.duration = widget.groupId;
                        order.isLoading ? const Center(child: CircularProgressIndicator()) :
                        order.addShippingMethod(context, shipping.id, shipping.duration);
                      },)
                      ],
                    ),
                  )  : const Center(child: Text('No method available')) : const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
