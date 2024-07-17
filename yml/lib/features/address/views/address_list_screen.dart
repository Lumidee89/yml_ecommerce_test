import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/features/address/controllers/address_controller.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/localization/provider/localization_provider.dart';
import 'package:yml_ecommerce_test/theme/provider/theme_provider.dart';
import 'package:yml_ecommerce_test/utill/color_resources.dart';
import 'package:yml_ecommerce_test/utill/custom_themes.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/utill/images.dart';
import 'package:yml_ecommerce_test/basewidget/custom_app_bar.dart';
import 'package:yml_ecommerce_test/basewidget/no_internet_screen.dart';
import 'package:yml_ecommerce_test/basewidget/remove_address_bottom_sheet.dart';
import 'package:yml_ecommerce_test/features/address/views/add_new_address_screen.dart';
import 'package:yml_ecommerce_test/features/chat/widget/inbox_shimmer.dart';
import 'package:provider/provider.dart';

class AddressListScreen extends StatefulWidget {
  const AddressListScreen({super.key});
  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  @override
  void initState() {
    Provider.of<AddressController>(context, listen: false).initAddressList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('addresses', context)),
      floatingActionButton: FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const AddNewAddressScreen(isBilling: false))),
          backgroundColor: ColorResources.getPrimary(context),
          child: Icon(Icons.add, color: Theme.of(context).highlightColor)),
      body: Consumer<AddressController>(
        builder: (context, locationProvider, child) {
          return !locationProvider.isLoading
              ? locationProvider.shippingAddressList.isNotEmpty
                  ? RefreshIndicator(
                      onRefresh: () async {
                        await locationProvider.initAddressList();
                      },
                      backgroundColor: Theme.of(context).primaryColor,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(0),
                        itemCount: locationProvider.shippingAddressList.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Card(
                            child: Stack(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: ListTile(
                                    title: Text(
                                        '${getTranslated('address', context)} : ${locationProvider.shippingAddressList[index].address}'),
                                    subtitle: Row(children: [
                                      Expanded(
                                          child: Text(
                                              '${getTranslated('city', context)} : ${locationProvider.shippingAddressList[index].city ?? ""}')),
                                      const SizedBox(
                                          width: Dimensions.paddingSizeDefault),
                                      Expanded(
                                          child: Text(
                                              '${getTranslated('zip', context)} : ${locationProvider.shippingAddressList[index].zip ?? ""}')),
                                    ]),
                                    trailing: InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                              backgroundColor:
                                                  Colors.transparent,
                                              context: context,
                                              builder: (_) =>
                                                  RemoveFromAddressBottomSheet(
                                                    addressId: locationProvider
                                                        .shippingAddressList[
                                                            index]
                                                        .id!,
                                                    index: index,
                                                  ));
                                        },
                                        child: const Padding(
                                            padding: EdgeInsets.only(
                                                top: Dimensions
                                                    .paddingSizeDefault),
                                            child: Icon(Icons.delete_forever,
                                                color: Colors.red))),
                                  ),
                                ),
                                Positioned(
                                  child: Align(
                                    alignment:
                                        Provider.of<LocalizationProvider>(
                                                    context)
                                                .isLtr
                                            ? Alignment.topRight
                                            : Alignment.topLeft,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: Provider.of<
                                                          LocalizationProvider>(
                                                      context)
                                                  .isLtr
                                              ? const BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(5),
                                                  topLeft: Radius.circular(5))
                                              : const BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(5),
                                                  topRight: Radius.circular(5)),
                                          color:
                                              Theme.of(context).primaryColor),
                                      child: Padding(
                                        padding: const EdgeInsets.all(7.0),
                                        child: Text(
                                          locationProvider
                                                      .shippingAddressList[
                                                          index]
                                                      .isBilling ==
                                                  0
                                              ? getTranslated(
                                                  'shipping', context)!
                                              : getTranslated(
                                                  'billing', context)!,
                                          style: textRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall,
                                              color: Provider.of<ThemeProvider>(
                                                          context)
                                                      .darkTheme
                                                  ? Colors.white
                                                  : Theme.of(context)
                                                      .cardColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : const NoInternetOrDataScreen(
                      isNoInternet: false,
                      message: 'no_address_found',
                      icon: Images.noAddress,
                    )
              : const InboxShimmer();
        },
      ),
    );
  }
}
