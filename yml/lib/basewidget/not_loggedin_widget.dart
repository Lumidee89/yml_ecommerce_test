import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/utill/custom_themes.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/utill/images.dart';
import 'package:yml_ecommerce_test/basewidget/custom_button.dart';
import 'package:yml_ecommerce_test/features/auth/views/auth_screen.dart';
import 'package:yml_ecommerce_test/features/dashboard/dashboard_screen.dart';

class NotLoggedInWidget extends StatelessWidget {
  const NotLoggedInWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
          child: SizedBox(width: 60,child: Image.asset(Images.loginIcon)),),
        Text(getTranslated('please_login', context)!, style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge),),

        Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeLarge),
          child: Text('${getTranslated('need_to_login', context)}'),),

        Center(child: SizedBox(width: 120,child: CustomButton(buttonText: '${getTranslated('login', context)}',
            backgroundColor: Theme.of(context).primaryColor,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthScreen()))))),

      InkWell(onTap: ()=> Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=> const DashBoardScreen()), (route) => false),
        child: Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
          child: Text(getTranslated('back_to_home', context)!,
            style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge,
                color: Theme.of(context).primaryColor, decoration: TextDecoration.underline),)),
      ),
      ],
    );
  }
}
