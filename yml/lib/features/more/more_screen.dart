import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/features/loyaltyPoint/provider/loyalty_point_provider.dart';
import 'package:yml_ecommerce_test/helper/price_converter.dart';
import 'package:yml_ecommerce_test/features/cart/controllers/cart_controller.dart';
import 'package:yml_ecommerce_test/features/notification/provider/notification_provider.dart';
import 'package:yml_ecommerce_test/features/wallet/provider/wallet_provider.dart';
import 'package:yml_ecommerce_test/basewidget/logout_confirm_bottom_sheet.dart';
import 'package:yml_ecommerce_test/features/auth/views/auth_screen.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/features/auth/controllers/auth_controller.dart';
import 'package:yml_ecommerce_test/features/profile/provider/profile_provider.dart';
import 'package:yml_ecommerce_test/features/splash/provider/splash_provider.dart';
import 'package:yml_ecommerce_test/theme/provider/theme_provider.dart';
import 'package:yml_ecommerce_test/utill/color_resources.dart';
import 'package:yml_ecommerce_test/utill/custom_themes.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/utill/images.dart';
import 'package:yml_ecommerce_test/features/more/widget/more_header_section.dart';
import 'package:yml_ecommerce_test/features/more/widget/more_horizontal_section.dart';
import 'package:provider/provider.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});
  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  late bool isGuestMode;
  String? version;
  bool singleVendor = false;


  @override
  void initState() {
    isGuestMode = !Provider.of<AuthController>(context, listen: false).isLoggedIn();
    if(Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
      version = Provider.of<SplashProvider>(context,listen: false).configModel!.softwareVersion ?? 'version';
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
      if(Provider.of<SplashProvider>(context,listen: false).configModel!.walletStatus == 1){
        Provider.of<WalletTransactionProvider>(context, listen: false).getTransactionList(context,1, 'all');
      }
      if(Provider.of<SplashProvider>(context,listen: false).configModel!.loyaltyPointStatus == 1){
        Provider.of<LoyaltyPointProvider>(context, listen: false).getLoyaltyPointList(context,1);
      }
    }
    singleVendor = Provider.of<SplashProvider>(context, listen: false).configModel!.businessMode == "single";

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [

          const MoreHeaderSection(),

          Container(decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [


                const Padding(padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                  child: Center(child: MoreHorizontalSection())),

                     ListTile(
                      leading: SizedBox(width: 30, child: Image.asset(Images.logOut, color: Theme.of(context).primaryColor,)),
                      title: Text(isGuestMode? getTranslated('sign_in', context)! : getTranslated('sign_out', context)!,
                          style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                      onTap: (){
                        if(isGuestMode){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthScreen()));
                        }else{
                          showModalBottomSheet(backgroundColor: Colors.transparent,
                              context: context, builder: (_)=>  const LogoutCustomBottomSheet());
                        }
                      },
                    ),
                  ]),
            ),
          ),
        ]),
      ),
    );
  }
}

class SquareButton extends StatelessWidget {
  final String image;
  final String? title;
  final Widget navigateTo;
  final int count;
  final bool hasCount;
  final bool isWallet;
  final double? balance;
  final bool isLoyalty;
  final String? subTitle;

  const SquareButton({super.key, required this.image,
    required this.title, required this.navigateTo, required this.count,
    required this.hasCount, this.isWallet = false, this.balance, this.subTitle,
     this.isLoyalty = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => navigateTo)),
      child: Column(children: [
        Padding(padding: const EdgeInsets.all(8.0),
          child: Container(width: 120, height: 90,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
              color: Provider.of<ThemeProvider>(context).darkTheme ?
              Theme.of(context).primaryColor.withOpacity(.30) : Theme.of(context).primaryColor),
            child: Stack(children: [
                Positioned(top: -80,left: -10,right: -10,
                  child: Container(height: 120, decoration: BoxDecoration(
                  border: Border.all(color: Colors.white.withOpacity(.07), width: 15),
                  borderRadius: BorderRadius.circular(100)))),


              isWallet?
              Padding(padding: const EdgeInsets.all(8.0),
                child: SizedBox(width: 30, height: 30,child: Image.asset(image, color: Colors.white)),
              ):

              Center(child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                    child: Image.asset(image, color: ColorResources.white))),

                if(isWallet)
                  Positioned(right: 10,bottom: 10,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text(getTranslated(subTitle, context)??'', style: textRegular.copyWith(color: Colors.white),),
                      isLoyalty? Text(balance != null? balance!.toStringAsFixed(0) : '0',
                        style: textMedium.copyWith(color: Colors.white)):
                      Text(balance != null? PriceConverter.convertPrice(context, balance):'0',
                        style: textMedium.copyWith(color: Colors.white)),
                    ],),
                  ),

                hasCount?
                Positioned(top: 5, right: 5,
                  child: Consumer<CartController>(builder: (context, cart, child) {
                    return CircleAvatar(radius: 10, backgroundColor: ColorResources.red,
                      child: Text(count.toString(),
                          style: titilliumSemiBold.copyWith(color: Theme.of(context).cardColor,
                            fontSize: Dimensions.fontSizeExtraSmall,
                          )),
                    );
                  }),
                ):const SizedBox(),
              ],
            ),
          ),
        ),
        Text(title??'', maxLines: 1,overflow: TextOverflow.clip,
            style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)),
      ]),
    );
  }
}

class TitleButton extends StatelessWidget {
  final String image;
  final String? title;
  final Widget navigateTo;
  final bool isNotification;
  final bool isProfile;
  const TitleButton({super.key, required this.image, required this.title, required this.navigateTo,  this.isNotification = false, this.isProfile = false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: isNotification? Consumer<NotificationProvider>(
        builder: (context, notificationProvider, _) {
          return CircleAvatar(radius: 12, backgroundColor: Theme.of(context).primaryColor,
            child: Text(notificationProvider.notificationModel?.newNotificationItem.toString() ?? '0',
                style: textRegular.copyWith(color: ColorResources.white, fontSize: Dimensions.fontSizeSmall,
                )),
          );
        }
      ): isProfile? Consumer<ProfileProvider>(
          builder: (context, profileProvider, _) {
            return CircleAvatar(radius: 12, backgroundColor: Theme.of(context).primaryColor,
              child: Text(profileProvider.userInfoModel?.referCount.toString() ?? '0',
                  style: textRegular.copyWith(color: ColorResources.white, fontSize: Dimensions.fontSizeSmall,
                  )),
            );
          }
      ): const SizedBox(),
      leading: Image.asset(image, width: 25, height: 25, fit: BoxFit.fill, color: Theme.of(context).primaryColor.withOpacity(.6),),
      title: Text(title!, style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
      onTap: () => Navigator.push(
        context, MaterialPageRoute(builder: (_) => navigateTo),
      ),
    );
  }
}

