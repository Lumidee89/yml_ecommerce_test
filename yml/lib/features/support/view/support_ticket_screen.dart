import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/features/support/domain/model/support_ticket_model.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/features/auth/controllers/auth_controller.dart';
import 'package:yml_ecommerce_test/features/support/provider/support_ticket_provider.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/utill/images.dart';
import 'package:yml_ecommerce_test/basewidget/custom_app_bar.dart';
import 'package:yml_ecommerce_test/basewidget/custom_button.dart';
import 'package:yml_ecommerce_test/basewidget/no_internet_screen.dart';
import 'package:yml_ecommerce_test/basewidget/not_loggedin_widget.dart';
import 'package:yml_ecommerce_test/features/support/widget/support_ticket_item.dart';
import 'package:yml_ecommerce_test/features/support/widget/support_ticket_shimmer.dart';
import 'package:yml_ecommerce_test/features/support/widget/support_ticket_type_widget.dart';
import 'package:provider/provider.dart';


class SupportTicketScreen extends StatefulWidget {
  const SupportTicketScreen({super.key});
  @override
  State<SupportTicketScreen> createState() => _SupportTicketScreenState();
}

class _SupportTicketScreenState extends State<SupportTicketScreen> {
  @override
  void initState() {
    if (Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
      Provider.of<SupportTicketProvider>(context, listen: false).getSupportTicketList();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: getTranslated('support_ticket', context)),
        bottomNavigationBar: Provider.of<AuthController>(context, listen: false).isLoggedIn()?
        SizedBox(height: 70,
          child: InkWell(onTap: () {showModalBottomSheet(context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (con) => const SupportTicketTypeWidget());
            }, child: Padding(padding: const EdgeInsets.all(8.0),
            child: CustomButton(radius: Dimensions.paddingSizeExtraSmall, buttonText: getTranslated('add_new_ticket', context)),)),):const SizedBox(),
      body: Provider.of<AuthController>(context, listen: false).isLoggedIn()? Provider.of<SupportTicketProvider>(context).supportTicketList != null ?
      Provider.of<SupportTicketProvider>(context).supportTicketList!.isNotEmpty ?
      Consumer<SupportTicketProvider>(
        builder: (context, support, child) {
            List<SupportTicketModel> supportTicketList = support.supportTicketList!.reversed.toList();
            return RefreshIndicator(onRefresh: () async => await support.getSupportTicketList(),
              child: ListView.builder(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                itemCount: supportTicketList.length,
                itemBuilder: (context, index) {
                  return SupportTicketWidget(supportTicketModel: supportTicketList[index]);
                },
              ),
            );
          },
        ) : const NoInternetOrDataScreen(isNoInternet: false, icon: Images.noTicket,
      message: 'no_ticket_created',) : const SupportTicketShimmer():const NotLoggedInWidget(),
      );
  }
}



