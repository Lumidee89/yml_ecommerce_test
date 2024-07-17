import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/features/auth/controllers/auth_controller.dart';
import 'package:yml_ecommerce_test/utill/custom_themes.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/utill/images.dart';
import 'package:yml_ecommerce_test/basewidget/custom_button.dart';
import 'package:yml_ecommerce_test/basewidget/custom_textfield.dart';
import 'package:yml_ecommerce_test/basewidget/show_custom_snakbar.dart';
import 'package:provider/provider.dart';


class ResetPasswordWidget extends StatefulWidget {
  final String mobileNumber;
  final String otp;
  const ResetPasswordWidget({super.key,required this.mobileNumber,required this.otp});

  @override
  ResetPasswordWidgetState createState() => ResetPasswordWidgetState();
}

class ResetPasswordWidgetState extends State<ResetPasswordWidget> {
  TextEditingController? _passwordController;
  TextEditingController? _confirmPasswordController;
  final FocusNode _newPasswordNode = FocusNode();
  final FocusNode _confirmPasswordNode = FocusNode();
  GlobalKey<FormState>? _formKeyReset;

  @override
  void initState() {
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    super.initState();
  }


  void resetPassword() async {
      String password = _passwordController!.text.trim();
      String confirmPassword = _confirmPasswordController!.text.trim();

      if (password.isEmpty) {
        showCustomSnackBar(getTranslated('PASSWORD_MUST_BE_REQUIRED', context), context);
      } else if (confirmPassword.isEmpty) {
        showCustomSnackBar(getTranslated('CONFIRM_PASSWORD_MUST_BE_REQUIRED', context), context);
      }else if (password != confirmPassword) {
        showCustomSnackBar(getTranslated('PASSWORD_DID_NOT_MATCH', context), context);
      } else {
        Provider.of<AuthController>(context, listen: false).resetPassword(widget.mobileNumber,widget.otp, password, confirmPassword);
      }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(key: _formKeyReset,
        child: ListView(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall), children: [
            Padding(padding: const EdgeInsets.all(50),
              child: Image.asset(Images.logoWithNameImage, height: 150, width: 200),),

            Padding(padding: const EdgeInsets.all(Dimensions.marginSizeLarge),
              child: Text(getTranslated('password_reset', context)!, style: titilliumSemiBold)),
            // for new password
            Container(margin: const EdgeInsets.only(left: Dimensions.marginSizeLarge, right: Dimensions.marginSizeLarge,
                bottom: Dimensions.marginSizeSmall),
                child: CustomTextField(
                  hintText: getTranslated('new_password', context),
                  focusNode: _newPasswordNode,
                  nextFocus: _confirmPasswordNode,
                  isPassword: true,
                  controller: _passwordController)),


            Container(margin: const EdgeInsets.only(left: Dimensions.marginSizeLarge, right: Dimensions.marginSizeLarge,
                bottom: Dimensions.marginSizeDefault),
                child: CustomTextField(
                  isPassword: true,
                  hintText: getTranslated('confirm_password', context),
                  inputAction: TextInputAction.done,
                  focusNode: _confirmPasswordNode,
                  controller: _confirmPasswordController)),


            Container(margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 30),
              child: Provider.of<AuthController>(context).isLoading ?
              Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)))
                  : CustomButton(onTap: resetPassword, buttonText: getTranslated('reset_password', context))),

          ],
        ),
      ),
    );
  }
}
