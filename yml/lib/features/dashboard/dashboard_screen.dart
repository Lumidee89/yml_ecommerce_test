import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/features/wishlist/view/wishlist_screen.dart';
import 'package:yml_ecommerce_test/helper/network_info.dart';
import 'package:yml_ecommerce_test/features/splash/provider/splash_provider.dart';
import 'package:yml_ecommerce_test/utill/custom_themes.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/basewidget/custom_exit_card.dart';
import 'package:yml_ecommerce_test/features/chat/view/inbox_screen.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/utill/images.dart';
import 'package:yml_ecommerce_test/features/home/view/aster_theme_home_page.dart';
import 'package:yml_ecommerce_test/features/home/view/fashion_theme_home_page.dart';
import 'package:yml_ecommerce_test/features/home/view/home_screens.dart';
import 'package:yml_ecommerce_test/features/more/more_screen.dart';
import 'package:yml_ecommerce_test/features/order/view/order_screen.dart';
import 'package:provider/provider.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  DashBoardScreenState createState() => DashBoardScreenState();
}

class DashBoardScreenState extends State<DashBoardScreen> {
  int _pageIndex = 0;
  late List<NavigationModel> _screens;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  final PageStorageBucket bucket = PageStorageBucket();

  bool singleVendor = false;
  @override
  void initState() {
    super.initState();
    singleVendor = Provider.of<SplashProvider>(context, listen: false)
            .configModel!
            .businessMode ==
        "single";

    _screens = [
      NavigationModel(
          name: 'home',
          icon: Images.homeImage,
          screen: (Provider.of<SplashProvider>(context, listen: false)
                      .configModel!
                      .activeTheme ==
                  "default")
              ? const HomePage()
              : (Provider.of<SplashProvider>(context, listen: false)
                          .configModel!
                          .activeTheme ==
                      "theme_aster")
                  ? const AsterThemeHomePage()
                  : const FashionThemeHomePage()),
      if (!singleVendor)
        NavigationModel(
            name: 'inbox',
            icon: Images.messageImage,
            screen: const InboxScreen(isBackButtonExist: false)),
      NavigationModel(
          name: 'orders',
          icon: Images.shoppingImage,
          screen: const OrderScreen(isBacButtonExist: false)),
      NavigationModel(
          name: 'wishlist', icon: Images.wishlist, screen: const WishListScreen()),
      NavigationModel(
          name: 'account', icon: Images.moreImage, screen: const MoreScreen()),
    ];

    NetworkInfo.checkConnectivity(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (val) async {
        if (_pageIndex != 0) {
          _setPage(0);
          return;
        } else {
          showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (_) => const CustomExitCard());
        }
        return;
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: PageStorage(bucket: bucket, child: _screens[_pageIndex].screen),
        bottomNavigationBar: Container(
          height: 65,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(Dimensions.paddingSizeLarge)),
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                  offset: const Offset(1, 1),
                  blurRadius: 2,
                  spreadRadius: 1,
                  color: Theme.of(context).primaryColor.withOpacity(.125))
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _getBottomWidget(singleVendor),
          ),
        ),
      ),
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageIndex = pageIndex;
    });
  }

  List<Widget> _getBottomWidget(bool isSingleVendor) {
    List<Widget> list = [];
    for (int index = 0; index < _screens.length; index++) {
      list.add(Expanded(
          child: CustomMenuItem(
        isSelected: _pageIndex == index,
        name: _screens[index].name,
        icon: _screens[index].icon,
        onTap: () => _setPage(index),
      )));
    }
    return list;
  }
}

class CustomMenuItem extends StatelessWidget {
  final bool isSelected;
  final String name;
  final String icon;
  final VoidCallback onTap;

  const CustomMenuItem({
    super.key,
    required this.isSelected,
    required this.name,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
            width: isSelected ? 90 : 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(icon,
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).hintColor,
                    width: Dimensions.menuIconSize,
                    height: Dimensions.menuIconSize),
                isSelected
                    ? Text(getTranslated(name, context)!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textBold.copyWith(
                            color: Theme.of(context).primaryColor))
                    : Text(getTranslated(name, context)!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textRegular.copyWith(
                            color: Theme.of(context).hintColor)),
                if (isSelected)
                  Container(
                    width: 5,
                    height: 3,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(
                            Dimensions.paddingSizeDefault)),
                  )
              ],
            )),
      ),
    );
  }
}

class NavigationModel {
  String name;
  String icon;
  Widget screen;
  NavigationModel(
      {required this.name, required this.icon, required this.screen});
}
