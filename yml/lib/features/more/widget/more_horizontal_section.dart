import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/features/more/more_screen.dart';
import 'package:yml_ecommerce_test/features/wishlist/provider/wishlist_provider.dart';
import 'package:yml_ecommerce_test/features/auth/controllers/auth_controller.dart';
import 'package:yml_ecommerce_test/features/profile/provider/profile_provider.dart';
import 'package:yml_ecommerce_test/features/splash/provider/splash_provider.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/utill/images.dart';
import 'package:yml_ecommerce_test/features/loyaltyPoint/view/loyalty_point_screen.dart';
import 'package:yml_ecommerce_test/features/offer/offers_screen.dart';
import 'package:yml_ecommerce_test/features/wallet/view/wallet_screen.dart';
import 'package:yml_ecommerce_test/features/wishlist/view/wishlist_screen.dart';
import 'package:provider/provider.dart';

class MoreHorizontalSection extends StatelessWidget {
  const MoreHorizontalSection({super.key});

  @override
  Widget build(BuildContext context) {
    bool isGuestMode = !Provider.of<AuthController>(context, listen: false).isLoggedIn();
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider,_) {
        return SizedBox(height: 130,
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
            child: Center(
              child: ListView(scrollDirection:Axis.horizontal,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(), children: [
                   if(Provider.of<SplashProvider>(context, listen: false).configModel!.activeTheme != "theme_fashion")
                    SquareButton(image: Images.offerIcon, title: getTranslated('offers', context),
                      navigateTo: const OffersScreen(),count: 0,hasCount: false,),

                    if(!isGuestMode && Provider.of<SplashProvider>(context,listen: false).configModel!.walletStatus == 1)
                      SquareButton(image: Images.wallet, title: getTranslated('wallet', context),
                          navigateTo: const WalletScreen(),count: 1,hasCount: false,
                          subTitle: 'amount', isWallet: true, balance: Provider.of<ProfileProvider>(context, listen: false).balance),


                    if(!isGuestMode && Provider.of<SplashProvider>(context,listen: false).configModel!.loyaltyPointStatus == 1)
                      SquareButton(image: Images.loyaltyPoint, title: getTranslated('loyalty_point', context),
                        navigateTo: const LoyaltyPointScreen(),count: 1,hasCount: false,isWallet: true,subTitle: 'point',
                        balance: Provider.of<ProfileProvider>(context, listen: false).loyaltyPoint, isLoyalty: true,
                      ),

                    SquareButton(image: Images.wishlist, title: getTranslated('wishlist', context),
                      navigateTo: const WishListScreen(),
                      count: Provider.of<AuthController>(context, listen: false).isLoggedIn() &&
                          Provider.of<WishListProvider>(context, listen: false).wishList != null &&
                          Provider.of<WishListProvider>(context, listen: false).wishList!.isNotEmpty ?
                      Provider.of<WishListProvider>(context, listen: false).wishList!.length : 0, hasCount: false,),
                  ]),
            ),
          ),
        );
      }
    );
  }
}
