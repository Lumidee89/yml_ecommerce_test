import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/features/address/controllers/address_controller.dart';
import 'package:yml_ecommerce_test/features/cart/domain/models/cart_model.dart';
import 'package:yml_ecommerce_test/features/checkout/provider/checkout_provider.dart';
import 'package:yml_ecommerce_test/helper/price_converter.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/main.dart';
import 'package:yml_ecommerce_test/features/auth/controllers/auth_controller.dart';
import 'package:yml_ecommerce_test/features/cart/controllers/cart_controller.dart';
import 'package:yml_ecommerce_test/features/coupon/provider/coupon_provider.dart';
import 'package:yml_ecommerce_test/features/order/provider/order_provider.dart';
import 'package:yml_ecommerce_test/features/profile/provider/profile_provider.dart';
import 'package:yml_ecommerce_test/features/splash/provider/splash_provider.dart';
import 'package:yml_ecommerce_test/utill/custom_themes.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/basewidget/amount_widget.dart';
import 'package:yml_ecommerce_test/basewidget/animated_custom_dialog.dart';
import 'package:yml_ecommerce_test/basewidget/custom_app_bar.dart';
import 'package:yml_ecommerce_test/basewidget/custom_button.dart';
import 'package:yml_ecommerce_test/basewidget/order_place_success_dialog.dart';
import 'package:yml_ecommerce_test/basewidget/show_custom_snakbar.dart';
import 'package:yml_ecommerce_test/basewidget/custom_textfield.dart';
import 'package:yml_ecommerce_test/features/checkout/widget/choose_payment_section.dart';
import 'package:yml_ecommerce_test/features/checkout/widget/coupon_apply_widget.dart';
import 'package:yml_ecommerce_test/features/checkout/widget/shipping_details_widget.dart';
import 'package:yml_ecommerce_test/features/checkout/widget/wallet_payment.dart';
import 'package:yml_ecommerce_test/features/dashboard/dashboard_screen.dart';
import 'package:yml_ecommerce_test/features/offline_payment/view/offline_payment.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartModel> cartList;
  final bool fromProductDetails;
  final double totalOrderAmount;
  final double shippingFee;
  final double discount;
  final double tax;
  final int? sellerId;
  final bool onlyDigital;
  final bool hasPhysical;
  final int quantity;

  const CheckoutScreen(
      {super.key,
      required this.cartList,
      this.fromProductDetails = false,
      required this.discount,
      required this.tax,
      required this.totalOrderAmount,
      required this.shippingFee,
      this.sellerId,
      this.onlyDigital = false,
      required this.quantity,
      required this.hasPhysical});

  @override
  CheckoutScreenState createState() => CheckoutScreenState();
}

class CheckoutScreenState extends State<CheckoutScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _controller = TextEditingController();

  final FocusNode _orderNoteNode = FocusNode();
  double _order = 0;
  late bool _billingAddress;
  double? _couponDiscount;

  @override
  void initState() {
    super.initState();
    Provider.of<AddressController>(context, listen: false).initAddressList();
    Provider.of<CouponProvider>(context, listen: false).removePrevCouponData();
    Provider.of<CartController>(context, listen: false).getCartDataAPI(context);
    Provider.of<CheckOutProvider>(context, listen: false).resetPaymentMethod();
    Provider.of<CartController>(context, listen: false)
        .getChosenShippingMethod(context);
    if (Provider.of<SplashProvider>(context, listen: false).configModel !=
            null &&
        Provider.of<SplashProvider>(context, listen: false)
                .configModel!
                .offlinePayment !=
            null) {
      Provider.of<CheckOutProvider>(context, listen: false)
          .getOfflinePaymentList();
    }

    if (Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
      Provider.of<CouponProvider>(context, listen: false)
          .getAvailableCouponList();
    }

    _billingAddress = Provider.of<SplashProvider>(Get.context!, listen: true)
            .configModel!
            .billingInputByCustomer ==
        1;
  }

  @override
  Widget build(BuildContext context) {
    _order = widget.totalOrderAmount + widget.discount;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      bottomNavigationBar:
          Consumer<AddressController>(builder: (context, locationProvider, _) {
        return Consumer<CheckOutProvider>(
            builder: (context, orderProvider, child) {
          return Consumer<CouponProvider>(
              builder: (context, couponProvider, _) {
            return Consumer<CartController>(
                builder: (context, cartProvider, _) {
              return Consumer<ProfileProvider>(
                  builder: (context, profileProvider, _) {
                return orderProvider.isLoading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator()),
                        ],
                      )
                    : Padding(
                        padding:
                            const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        child: CustomButton(
                          onTap: () async {
                            if (orderProvider.addressIndex == null &&
                                widget.hasPhysical) {
                              log("message");
                              showCustomSnackBar(
                                  getTranslated(
                                      'select_a_shipping_address', context),
                                  context,
                                  isToaster: true);
                            } else if ((orderProvider.billingAddressIndex ==
                                        null &&
                                    !widget.hasPhysical) ||
                                (orderProvider.billingAddressIndex == null &&
                                    _billingAddress)) {
                              showCustomSnackBar(
                                  getTranslated(
                                      'select_a_billing_address', context),
                                  context,
                                  isToaster: true);
                            } else {
                              String orderNote =
                                  orderProvider.orderNoteController.text.trim();
                              String couponCode =
                                  couponProvider.discount != null &&
                                          couponProvider.discount != 0
                                      ? couponProvider.couponCode
                                      : '';
                              String couponCodeAmount =
                                  couponProvider.discount != null &&
                                          couponProvider.discount != 0
                                      ? couponProvider.discount.toString()
                                      : '0';
                              String addressId = !widget.onlyDigital
                                  ? locationProvider
                                      .addressList![orderProvider.addressIndex!]
                                      .id
                                      .toString()
                                  : '';
                              String billingAddressId = (_billingAddress)
                                  ? locationProvider
                                      .billingAddressList[
                                          orderProvider.billingAddressIndex!]
                                      .id
                                      .toString()
                                  : '';

                              if (orderProvider.paymentMethodIndex != -1) {
                                orderProvider.digitalPayment(
                                    orderNote: orderNote,
                                    customerId: Provider.of<AuthController>(
                                                context,
                                                listen: false)
                                            .isLoggedIn()
                                        ? profileProvider.userInfoModel?.id
                                            .toString()
                                        : Provider.of<AuthController>(context,
                                                listen: false)
                                            .getGuestToken(),
                                    addressId: addressId,
                                    billingAddressId: billingAddressId,
                                    couponCode: couponCode,
                                    couponDiscount: couponCodeAmount,
                                    paymentMethod: orderProvider
                                        .selectedDigitalPaymentMethodName);
                              } else if (orderProvider.codChecked &&
                                  !widget.onlyDigital) {
                                orderProvider.placeOrder(
                                    callback: _callback,
                                    addressID:
                                        widget.onlyDigital ? '' : addressId,
                                    couponCode: couponCode,
                                    couponAmount: couponCodeAmount,
                                    billingAddressId: _billingAddress
                                        ? billingAddressId
                                        : widget.onlyDigital
                                            ? ''
                                            : addressId,
                                    orderNote: orderNote);
                              } else if (orderProvider.offlineChecked) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => OfflinePaymentScreen(
                                        payableAmount: _order,
                                        callback: _callback)));
                              } else if (orderProvider.walletChecked) {
                                showAnimatedDialog(context,
                                    Consumer<ProfileProvider>(
                                        builder: (context, profile, _) {
                                  return WalletPayment(
                                    currentBalance: profile.balance,
                                    orderAmount: _order +
                                        widget.shippingFee -
                                        widget.discount -
                                        _couponDiscount! +
                                        widget.tax,
                                    onTap: () {
                                      if (profile.balance! <
                                          (_order +
                                              widget.shippingFee -
                                              widget.discount -
                                              _couponDiscount! +
                                              widget.tax)) {
                                        showCustomSnackBar(
                                            getTranslated(
                                                'insufficient_balance',
                                                context),
                                            context,
                                            isToaster: true);
                                      } else {
                                        Navigator.pop(context);
                                        orderProvider.placeOrder(
                                            callback: _callback,
                                            wallet: true,
                                            addressID: widget.onlyDigital
                                                ? ''
                                                : locationProvider
                                                    .addressList![orderProvider
                                                        .addressIndex!]
                                                    .id
                                                    .toString(),
                                            couponCode: couponCode,
                                            couponAmount: couponCodeAmount,
                                            billingAddressId: _billingAddress
                                                ? locationProvider
                                                    .billingAddressList[
                                                        orderProvider
                                                            .billingAddressIndex!]
                                                    .id
                                                    .toString()
                                                : widget.onlyDigital
                                                    ? ''
                                                    : locationProvider
                                                        .addressList![
                                                            orderProvider
                                                                .addressIndex!]
                                                        .id
                                                        .toString(),
                                            orderNote: orderNote);
                                      }
                                    },
                                  );
                                }), dismissible: false, isFlip: true);
                              } else {
                                showCustomSnackBar(
                                    getTranslated(
                                        'select_payment_method', context),
                                    context);
                              }
                            }
                          },
                          buttonText: '${getTranslated('proceed', context)}',
                        ),
                      );
              });
            });
          });
        });
      }),
      appBar: CustomAppBar(title: getTranslated('checkout', context)),
      body: Consumer<AuthController>(builder: (context, authProvider, _) {
        return Consumer<CheckOutProvider>(builder: (context, orderProvider, _) {
          return Column(
            children: [
              Expanded(
                child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(0),
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(
                              bottom: Dimensions.paddingSizeDefault),
                          child: ShippingDetailsWidget(
                              hasPhysical: widget.hasPhysical,
                              billingAddress: _billingAddress)),
                      if (Provider.of<AuthController>(context, listen: false)
                          .isLoggedIn())
                        Padding(
                            padding: const EdgeInsets.only(
                                bottom: Dimensions.paddingSizeSmall),
                            child: CouponApplyWidget(
                                couponController: _controller,
                                orderAmount: _order)),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeSmall),
                          child: ChoosePaymentSection(
                              onlyDigital: widget.onlyDigital)),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(
                              Dimensions.paddingSizeDefault,
                              Dimensions.paddingSizeDefault,
                              Dimensions.paddingSizeDefault,
                              Dimensions.paddingSizeSmall),
                          child: Text(getTranslated('order_summary', context)!,
                              style: textMedium.copyWith(
                                  fontSize: Dimensions.fontSizeLarge))),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeDefault),
                        child: Consumer<OrderProvider>(
                          builder: (context, order, child) {
                            _couponDiscount =
                                Provider.of<CouponProvider>(context).discount ??
                                    0;

                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  widget.quantity > 1
                                      ? AmountWidget(
                                          title:
                                              '${getTranslated('sub_total', context)} ${' (${widget.quantity} ${getTranslated('items', context)}) '}',
                                          amount: PriceConverter.convertPrice(
                                              context, _order))
                                      : AmountWidget(
                                          title:
                                              '${getTranslated('sub_total', context)} ${'(${widget.quantity} ${getTranslated('item', context)})'}',
                                          amount: PriceConverter.convertPrice(
                                              context, _order)),
                                  AmountWidget(
                                      title: getTranslated(
                                          'shipping_fee', context),
                                      amount: PriceConverter.convertPrice(
                                          context, widget.shippingFee)),
                                  AmountWidget(
                                      title: getTranslated('discount', context),
                                      amount: PriceConverter.convertPrice(
                                          context, widget.discount)),
                                  AmountWidget(
                                      title: getTranslated(
                                          'coupon_voucher', context),
                                      amount: PriceConverter.convertPrice(
                                          context, _couponDiscount)),
                                  AmountWidget(
                                      title: getTranslated('tax', context),
                                      amount: PriceConverter.convertPrice(
                                          context, widget.tax)),
                                  Divider(
                                      height: 5,
                                      color: Theme.of(context).hintColor),
                                  AmountWidget(
                                      title: getTranslated(
                                          'total_payable', context),
                                      amount: PriceConverter.convertPrice(
                                          context,
                                          (_order +
                                              widget.shippingFee -
                                              widget.discount -
                                              _couponDiscount! +
                                              widget.tax))),
                                ]);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                            Dimensions.paddingSizeDefault,
                            Dimensions.paddingSizeDefault,
                            Dimensions.paddingSizeDefault,
                            0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Text('${getTranslated('order_note', context)}',
                                    style: textRegular.copyWith(
                                        fontSize: Dimensions.fontSizeLarge))
                              ]),
                              const SizedBox(
                                  height: Dimensions.paddingSizeSmall),
                              CustomTextField(
                                hintText: getTranslated('enter_note', context),
                                inputType: TextInputType.multiline,
                                inputAction: TextInputAction.done,
                                maxLines: 3,
                                focusNode: _orderNoteNode,
                                controller: orderProvider.orderNoteController,
                              ),
                            ]),
                      ),
                    ]),
              ),
            ],
          );
        });
      }),
    );
  }

  void _callback(bool isSuccess, String message, String orderID) async {
    if (isSuccess) {
      Navigator.of(Get.context!).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const DashBoardScreen()),
          (route) => false);
      showAnimatedDialog(
          context,
          OrderPlaceSuccessDialog(
            icon: Icons.check,
            title: getTranslated('order_placed', context),
            description: getTranslated('your_order_placed', context),
            isFailed: false,
          ),
          dismissible: false,
          isFlip: true);

      Provider.of<OrderProvider>(context, listen: false).stopLoader();
    } else {
      showCustomSnackBar(message, context, isToaster: true);
    }
  }
}
