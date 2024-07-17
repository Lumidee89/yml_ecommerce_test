import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/features/auth/domain/models/register_model.dart';
import 'package:yml_ecommerce_test/helper/email_checker.dart';
import 'package:yml_ecommerce_test/helper/velidate_check.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/main.dart';
import 'package:yml_ecommerce_test/features/auth/controllers/auth_controller.dart';
import 'package:yml_ecommerce_test/features/profile/provider/profile_provider.dart';
import 'package:yml_ecommerce_test/features/splash/provider/splash_provider.dart';
import 'package:yml_ecommerce_test/utill/color_resources.dart';
import 'package:yml_ecommerce_test/utill/custom_themes.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/utill/images.dart';
import 'package:yml_ecommerce_test/basewidget/custom_button.dart';
import 'package:yml_ecommerce_test/basewidget/show_custom_snakbar.dart';
import 'package:yml_ecommerce_test/basewidget/custom_textfield.dart';
import 'package:yml_ecommerce_test/features/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'otp_verification_screen.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({super.key});

  @override
  SignUpWidgetState createState() => SignUpWidgetState();
}

class SignUpWidgetState extends State<SignUpWidget> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _referController = TextEditingController();

  final FocusNode _fNameFocus = FocusNode();
  final FocusNode _lNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _referFocus = FocusNode();

  RegisterModel register = RegisterModel();

  route(bool isRoute, String? token, String? tempToken,
      String? errorMessage) async {
    String phone =
        Provider.of<AuthController>(context, listen: false).countryDialCode +
            _phoneController.text.trim();
    if (isRoute) {
      if (Provider.of<SplashProvider>(context, listen: false)
          .configModel!
          .emailVerification!) {
        Provider.of<AuthController>(context, listen: false)
            .sendOtpToEmail(_emailController.text.toString(), tempToken!)
            .then((value) async {
          if (value.response?.statusCode == 200) {
            Provider.of<AuthController>(context, listen: false)
                .updateEmail(_emailController.text.toString());
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) => VerificationScreen(
                        tempToken, '', _emailController.text.toString())),
                (route) => false);
          }
        });
      } else if (Provider.of<SplashProvider>(context, listen: false)
          .configModel!
          .phoneVerification!) {
        Provider.of<AuthController>(context, listen: false)
            .sendOtpToPhone(phone, tempToken!)
            .then((value) async {
          if (value.isSuccess) {
            Provider.of<AuthController>(context, listen: false)
                .updatePhone(phone);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) => VerificationScreen(tempToken, phone, '')),
                (route) => false);
          }
        });
      } else {
        await Provider.of<ProfileProvider>(context, listen: false)
            .getUserInfo(context);
        Navigator.pushAndRemoveUntil(
            Get.context!,
            MaterialPageRoute(builder: (_) => const DashBoardScreen()),
            (route) => false);
        _emailController.clear();
        _passwordController.clear();
        _firstNameController.clear();
        _lastNameController.clear();
        _phoneController.clear();
        _confirmPasswordController.clear();
        _referController.clear();
      }
    } else {
      showCustomSnackBar(errorMessage, context);
    }
  }

  @override
  void initState() {
    super.initState();
    Provider.of<AuthController>(context, listen: false).setCountryCode(
        CountryCode.fromCountryCode(
                Provider.of<SplashProvider>(context, listen: false)
                    .configModel!
                    .countryCode!)
            .dialCode!,
        notify: false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<AuthController>(builder: (context, authProvider, _) {
          return Consumer<SplashProvider>(
              builder: (context, splashProvider, _) {
            return Column(
              children: [
                Container(
                    margin: const EdgeInsets.only(
                        left: Dimensions.marginSizeDefault,
                        right: Dimensions.marginSizeDefault),
                    child: CustomTextField(
                        hintText: getTranslated('first_name', context),
                        labelText: getTranslated('first_name', context),
                        inputType: TextInputType.name,
                        required: true,
                        focusNode: _fNameFocus,
                        nextFocus: _lNameFocus,
                        prefixIcon: Images.username,
                        capitalization: TextCapitalization.words,
                        controller: _firstNameController,
                        validator: (value) => ValidateCheck.validateEmptyText(
                            value, "first_name_field_is_required"))),
                Container(
                    margin: const EdgeInsets.only(
                        left: Dimensions.marginSizeDefault,
                        right: Dimensions.marginSizeDefault,
                        top: Dimensions.marginSizeSmall),
                    child: CustomTextField(
                        hintText: getTranslated('last_name', context),
                        labelText: getTranslated('last_name', context),
                        focusNode: _lNameFocus,
                        prefixIcon: Images.username,
                        nextFocus: _emailFocus,
                        required: true,
                        capitalization: TextCapitalization.words,
                        controller: _lastNameController,
                        validator: (value) => ValidateCheck.validateEmptyText(
                            value, "last_name_field_is_required"))),
                Container(
                    margin: const EdgeInsets.only(
                        left: Dimensions.marginSizeDefault,
                        right: Dimensions.marginSizeDefault,
                        top: Dimensions.marginSizeSmall),
                    child: CustomTextField(
                        hintText: getTranslated('enter_your_email', context),
                        labelText: getTranslated('enter_your_email', context),
                        focusNode: _emailFocus,
                        nextFocus: _phoneFocus,
                        required: true,
                        inputType: TextInputType.emailAddress,
                        controller: _emailController,
                        prefixIcon: Images.email,
                        validator: (value) =>
                            ValidateCheck.validateEmail(value))),
                Container(
                    margin: const EdgeInsets.only(
                        left: Dimensions.marginSizeDefault,
                        right: Dimensions.marginSizeDefault,
                        top: Dimensions.marginSizeSmall),
                    child: CustomTextField(
                        hintText: getTranslated('enter_mobile_number', context),
                        labelText:
                            getTranslated('enter_mobile_number', context),
                        controller: _phoneController,
                        focusNode: _phoneFocus,
                        nextFocus: _passwordFocus,
                        required: true,
                        showCodePicker: true,
                        countryDialCode: authProvider.countryDialCode,
                        onCountryChanged: (CountryCode countryCode) {
                          authProvider.countryDialCode = countryCode.dialCode!;
                          authProvider.setCountryCode(countryCode.dialCode!);
                        },
                        isAmount: true,
                        validator: (value) => ValidateCheck.validateEmptyText(
                            value, "phone_must_be_required"),
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.phone)),
                Container(
                    margin: const EdgeInsets.only(
                        left: Dimensions.marginSizeDefault,
                        right: Dimensions.marginSizeDefault,
                        top: Dimensions.marginSizeSmall),
                    child: CustomTextField(
                        hintText:
                            getTranslated('minimum_password_length', context),
                        labelText: getTranslated('password', context),
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        isPassword: true,
                        required: true,
                        nextFocus: _confirmPasswordFocus,
                        inputAction: TextInputAction.next,
                        validator: (value) => ValidateCheck.validatePassword(
                            value, "password_must_be_required"),
                        prefixIcon: Images.pass)),
                Hero(
                    tag: 'user',
                    child: Container(
                        margin: const EdgeInsets.only(
                            left: Dimensions.marginSizeDefault,
                            right: Dimensions.marginSizeDefault,
                            top: Dimensions.marginSizeSmall),
                        child: CustomTextField(
                            isPassword: true,
                            required: true,
                            hintText:
                                getTranslated('re_enter_password', context),
                            labelText:
                                getTranslated('re_enter_password', context),
                            controller: _confirmPasswordController,
                            focusNode: _confirmPasswordFocus,
                            inputAction: TextInputAction.done,
                            validator: (value) =>
                                ValidateCheck.validateConfirmPassword(
                                    value, _passwordController.text.trim()),
                            prefixIcon: Images.pass))),
                if (splashProvider.configModel!.refEarningStatus != null &&
                    splashProvider.configModel!.refEarningStatus == "1")
                  Padding(
                      padding: const EdgeInsets.only(
                          top: Dimensions.paddingSizeDefault,
                          left: Dimensions.paddingSizeDefault),
                      child: Row(children: [
                        Text(getTranslated('refer_code', context) ?? '')
                      ])),
                if (splashProvider.configModel!.refEarningStatus != null &&
                    splashProvider.configModel!.refEarningStatus == "1")
                  Container(
                      margin: const EdgeInsets.only(
                          left: Dimensions.marginSizeDefault,
                          right: Dimensions.marginSizeDefault,
                          top: Dimensions.marginSizeSmall),
                      child: CustomTextField(
                          hintText: getTranslated('enter_refer_code', context),
                          labelText: getTranslated('enter_refer_code', context),
                          controller: _referController,
                          focusNode: _referFocus,
                          inputAction: TextInputAction.done)),
                Container(
                    margin: const EdgeInsets.only(
                        left: Dimensions.marginSizeLarge,
                        right: Dimensions.marginSizeLarge,
                        bottom: Dimensions.marginSizeLarge,
                        top: Dimensions.marginSizeLarge),
                    child: authProvider.isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).primaryColor)))
                        : Hero(
                            tag: 'onTap',
                            child: CustomButton(
                                onTap: () {
                                  String firstName =
                                      _firstNameController.text.trim();
                                  String lastName =
                                      _lastNameController.text.trim();
                                  String email = _emailController.text.trim();
                                  String phoneNumber =
                                      authProvider.countryDialCode +
                                          _phoneController.text.trim();
                                  String password =
                                      _passwordController.text.trim();
                                  String confirmPassword =
                                      _confirmPasswordController.text.trim();

                                  if (firstName.isEmpty) {
                                    showCustomSnackBar(
                                        getTranslated(
                                            'first_name_field_is_required',
                                            context),
                                        context);
                                  } else if (lastName.isEmpty) {
                                    showCustomSnackBar(
                                        getTranslated(
                                            'last_name_field_is_required',
                                            context),
                                        context);
                                  } else if (email.isEmpty) {
                                    showCustomSnackBar(
                                        getTranslated(
                                            'email_is_required', context),
                                        context);
                                  } else if (EmailChecker.isNotValid(email)) {
                                    showCustomSnackBar(
                                        getTranslated(
                                            'enter_valid_email_address',
                                            context),
                                        context);
                                  } else if (password.length < 8) {
                                    showCustomSnackBar(
                                        getTranslated(
                                            'minimum_password_length', context),
                                        context);
                                  } else if (password.isEmpty) {
                                    showCustomSnackBar(
                                        getTranslated(
                                            'password_is_required', context),
                                        context);
                                  } else if (confirmPassword.isEmpty) {
                                    showCustomSnackBar(
                                        getTranslated(
                                            'confirm_password_must_be_required',
                                            context),
                                        context);
                                  } else if (password != confirmPassword) {
                                    showCustomSnackBar(
                                        getTranslated(
                                            'password_did_not_match', context),
                                        context);
                                  } else {
                                    register.fName = firstName;
                                    register.lName = lastName;
                                    register.email = email;
                                    register.phone =
                                        phoneNumber.replaceAll("+", "");
                                    register.password = password;
                                    register.referCode =
                                        _referController.text.trim();
                                    register.guestId =
                                        Provider.of<AuthController>(context,
                                                    listen: false)
                                                .getGuestToken() ??
                                            '1';

                                    authProvider.registration(register, route);
                                  }
                                },
                                buttonText:
                                    getTranslated('sign_up', context)))),
                authProvider.isLoading
                    ? const SizedBox()
                    : Center(
                        child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: Dimensions.paddingSizeExtraLarge),
                        child: InkWell(
                          onTap: () {
                            authProvider.getGuestIdUrl();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const DashBoardScreen()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(getTranslated('skip_for_now', context)!,
                                  style: titilliumRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault,
                                      color:
                                          ColorResources.getPrimary(context))),
                              Icon(
                                Icons.arrow_forward,
                                size: 15,
                                color: Theme.of(context).primaryColor,
                              )
                            ],
                          ),
                        ),
                      )),
              ],
            );
          });
        }),
      ],
    );
  }
}
