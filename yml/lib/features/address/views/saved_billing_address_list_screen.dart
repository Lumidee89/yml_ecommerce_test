import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/features/address/controllers/address_controller.dart';
import 'package:yml_ecommerce_test/features/checkout/provider/checkout_provider.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/utill/color_resources.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/utill/images.dart';
import 'package:yml_ecommerce_test/basewidget/custom_app_bar.dart';
import 'package:yml_ecommerce_test/basewidget/no_internet_screen.dart';
import 'package:yml_ecommerce_test/features/address/widgets/address_type_widget.dart';
import 'package:provider/provider.dart';

import 'add_new_address_screen.dart';
class SavedBillingAddressListScreen extends StatefulWidget {
  const SavedBillingAddressListScreen({super.key});

  @override
  State<SavedBillingAddressListScreen> createState() => _SavedBillingAddressListScreenState();
}

class _SavedBillingAddressListScreenState extends State<SavedBillingAddressListScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const AddNewAddressScreen(isBilling: true))),
        backgroundColor: ColorResources.getPrimary(context),
        child: Icon(Icons.add, color: Theme.of(context).highlightColor)),

      appBar: CustomAppBar(title: getTranslated('BILLING_ADDRESS_LIST', context),),

      body: SafeArea(child: Consumer<AddressController>(
        builder: (context, locationProvider, child) {
          return SingleChildScrollView(
            child: Column(children: [
              locationProvider.billingAddressList.isNotEmpty ?  SizedBox(
                  child: ListView.builder(physics: const NeverScrollableScrollPhysics(),
                    itemCount: locationProvider.billingAddressList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {Provider.of<CheckOutProvider>(context, listen: false).setBillingAddressIndex(index);
                        Navigator.pop(context);
                        },
                        child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                          child: Container(margin: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                              color: ColorResources.getIconBg(context),
                              border: index == Provider.of<CheckOutProvider>(context).billingAddressIndex ? Border.all(width: 2, color: Theme.of(context).primaryColor) : null,),
                            child: AddressListPage(address: locationProvider.billingAddressList[index]))));})) :
              Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/3),
                 child: Center(child: Container(
                     alignment: Alignment.center,
                     margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
                     child: const NoInternetOrDataScreen(isNoInternet: false, message: 'no_address_found', icon: Images.noAddress))),
               ),
              ],
            ),
          );
        },
      )),
    );
  }
}
