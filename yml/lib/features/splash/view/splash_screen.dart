import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/push_notification/model/notification_body.dart';
import 'package:yml_ecommerce_test/features/auth/controllers/auth_controller.dart';
import 'package:yml_ecommerce_test/features/splash/provider/splash_provider.dart';
import 'package:yml_ecommerce_test/utill/app_constants.dart';
import 'package:yml_ecommerce_test/utill/color_resources.dart';
import 'package:yml_ecommerce_test/utill/custom_themes.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/utill/images.dart';
import 'package:yml_ecommerce_test/basewidget/no_internet_screen.dart';
import 'package:yml_ecommerce_test/features/auth/views/auth_screen.dart';
import 'package:yml_ecommerce_test/features/chat/view/inbox_screen.dart';
import 'package:yml_ecommerce_test/features/dashboard/dashboard_screen.dart';
import 'package:yml_ecommerce_test/features/maintenance/maintenance_screen.dart';
import 'package:yml_ecommerce_test/features/notification/view/notification_screen.dart';
import 'package:yml_ecommerce_test/features/onboarding/view/onboarding_screen.dart';
import 'package:yml_ecommerce_test/features/order/view/order_details_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  final NotificationBody? body;
  const SplashScreen({super.key, this.body});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  late StreamSubscription<ConnectivityResult> _onConnectivityChanged;

  @override
  void initState() {
    super.initState();

    bool firstTime = true;
    _onConnectivityChanged = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (!firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi &&
            result != ConnectivityResult.mobile;
        isNotConnected
            ? const SizedBox()
            : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: isNotConnected ? Colors.red : Colors.green,
            duration: Duration(seconds: isNotConnected ? 6000 : 3),
            content: Text(
                isNotConnected
                    ? getTranslated('no_connection', context)!
                    : getTranslated('connected', context)!,
                textAlign: TextAlign.center)));
        if (!isNotConnected) {
          _route();
        }
      }
      firstTime = false;
    });

    _route();
  }

  @override
  void dispose() {
    super.dispose();
    _onConnectivityChanged.cancel();
  }

  void _route() {
    Provider.of<SplashProvider>(context, listen: false)
        .initConfig(context)
        .then((bool isSuccess) {
      if (isSuccess) {
        Provider.of<SplashProvider>(context, listen: false)
            .initSharedPrefData();
        Timer(const Duration(seconds: 1), () {
          if (Provider.of<SplashProvider>(context, listen: false)
              .configModel!
              .maintenanceMode!) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => const MaintenanceScreen()));
          } else if (Provider.of<AuthController>(context, listen: false)
              .isLoggedIn()) {
            Provider.of<AuthController>(context, listen: false)
                .updateToken(context);
            if (widget.body != null) {
              if (widget.body!.type == 'order') {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        OrderDetailsScreen(orderId: widget.body!.orderId)));
              } else if (widget.body!.type == 'notification') {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const NotificationScreen()));
              } else {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => const InboxScreen(
                          isBackButtonExist: true,
                        )));
              }
            } else {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => const DashBoardScreen()));
            }
          } else if (Provider.of<SplashProvider>(context, listen: false)
              .showIntro()!) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => OnBoardingScreen(
                    indicatorColor: ColorResources.grey,
                    selectedIndicatorColor: Theme.of(context).primaryColor)));
          } else {
            if (Provider.of<AuthController>(context, listen: false)
                        .getGuestToken() !=
                    null &&
                Provider.of<AuthController>(context, listen: false)
                        .getGuestToken() !=
                    '1') {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => const DashBoardScreen()));
            } else {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => const AuthScreen()));
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      key: _globalKey,
      body: Provider.of<SplashProvider>(context).hasConnection
          ? Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                SizedBox(
                    width: 100, child: Image.asset(Images.icon, width: 100.0)),
                Text(AppConstants.appName,
                    style: textRegular.copyWith(
                        fontSize: Dimensions.fontSizeOverLarge,
                        color: Colors.white)),
                Padding(
                    padding:
                        const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                    child: Text(AppConstants.slogan,
                        style: textRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            color: Colors.white)))
              ]),
            )
          : const NoInternetOrDataScreen(
              isNoInternet: true, child: SplashScreen()),
    );
  }
}
