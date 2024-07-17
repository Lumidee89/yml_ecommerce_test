import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/helper/velidate_check.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/utill/images.dart';
import 'package:yml_ecommerce_test/basewidget/custom_app_bar.dart';
import 'package:yml_ecommerce_test/basewidget/custom_button.dart';
import 'package:yml_ecommerce_test/basewidget/custom_textfield.dart';

class GuestUserContactInformation extends StatefulWidget {
  const GuestUserContactInformation({super.key});

  @override
  State<GuestUserContactInformation> createState() => _GuestUserContactInformationState();
}

class _GuestUserContactInformationState extends State<GuestUserContactInformation> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('contact_information', context),),
      body: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: ListView(children: [
          const SizedBox(height: Dimensions.paddingSizeSmall),
          CustomTextField(controller: nameController,
            prefixIcon: Images.user,
            hintText: getTranslated('order_id', context),
              validator: (value) =>ValidateCheck.validateEmptyText(value, "please_enter_your_name"),
            labelText: getTranslated('order_id', context),),
          const SizedBox(height: Dimensions.paddingSizeDefault),


          CustomTextField(
            prefixIcon: Images.callIcon,
            controller: phoneNumberController,
            hintText: '123 1235 123',
            labelText: '${getTranslated('phone_number', context)}',),
          const SizedBox(height: Dimensions.paddingSizeExtraLarge),

          CustomTextField(controller: emailNumberController,
            prefixIcon: Images.email,
            hintText: getTranslated('email', context),
            validator: (value) =>ValidateCheck.validateEmail(value),
            labelText: getTranslated('email', context),),
          const SizedBox(height: Dimensions.paddingSizeDefault),


          CustomButton(buttonText: '${getTranslated('search_order', context)}'),


        ],),
      ),
    );
  }
}
