import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/main.dart';
import 'package:yml_ecommerce_test/features/auth/controllers/auth_controller.dart';
import 'package:yml_ecommerce_test/features/order/provider/order_provider.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/utill/images.dart';
import 'package:yml_ecommerce_test/basewidget/custom_app_bar.dart';
import 'package:yml_ecommerce_test/basewidget/no_internet_screen.dart';
import 'package:yml_ecommerce_test/basewidget/not_loggedin_widget.dart';
import 'package:yml_ecommerce_test/basewidget/paginated_list_view.dart';
import 'package:yml_ecommerce_test/features/order/widget/order_shimmer.dart';
import 'package:yml_ecommerce_test/features/order/widget/order_type_button.dart';
import 'package:yml_ecommerce_test/features/order/widget/order_widget.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  final bool isBacButtonExist;
  const OrderScreen({super.key, this.isBacButtonExist = true});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  ScrollController scrollController = ScrollController();
  bool isGuestMode =
      !Provider.of<AuthController>(Get.context!, listen: false).isLoggedIn();
  @override
  void initState() {
    if (!isGuestMode) {
      Provider.of<OrderProvider>(context, listen: false)
          .setIndex(0, notify: false);
      Provider.of<OrderProvider>(context, listen: false)
          .getOrderList(1, 'ongoing');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: getTranslated('order', context),
          isBackButtonExist: widget.isBacButtonExist),
      body: isGuestMode
          ? const NotLoggedInWidget()
          : Consumer<OrderProvider>(builder: (context, orderProvider, child) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                    child: Row(
                      children: [
                        OrderTypeButton(
                            text: getTranslated('RUNNING', context), index: 0),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        OrderTypeButton(
                            text: getTranslated('DELIVERED', context),
                            index: 1),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        OrderTypeButton(
                            text: getTranslated('CANCELED', context), index: 2),
                      ],
                    ),
                  ),
                  Expanded(
                      child: orderProvider.orderModel != null
                          ? (orderProvider.orderModel!.orders != null &&
                                  orderProvider.orderModel!.orders!.isNotEmpty)
                              ? SingleChildScrollView(
                                  controller: scrollController,
                                  child: PaginatedListView(
                                    scrollController: scrollController,
                                    onPaginate: (int? offset) async {
                                      await Provider.of<OrderProvider>(context,
                                              listen: false)
                                          .getOrderList(offset!,
                                              orderProvider.selectedType);
                                    },
                                    totalSize:
                                        orderProvider.orderModel?.totalSize,
                                    offset: orderProvider.orderModel?.offset !=
                                            null
                                        ? int.parse(
                                            orderProvider.orderModel!.offset!)
                                        : 1,
                                    itemView: ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: orderProvider
                                          .orderModel?.orders!.length,
                                      padding: const EdgeInsets.all(0),
                                      itemBuilder: (context, index) =>
                                          OrderWidget(
                                              orderModel: orderProvider
                                                  .orderModel?.orders![index]),
                                    ),
                                  ),
                                )
                              : const NoInternetOrDataScreen(
                                  isNoInternet: false,
                                  icon: Images.noOrder,
                                  message: 'no_order_found',
                                )
                          : const OrderShimmer())
                ],
              );
            }),
    );
  }
}
