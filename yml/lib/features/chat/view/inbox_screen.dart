import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/features/auth/controllers/auth_controller.dart';
import 'package:yml_ecommerce_test/features/chat/provider/chat_provider.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/utill/images.dart';
import 'package:yml_ecommerce_test/basewidget/custom_app_bar.dart';
import 'package:yml_ecommerce_test/basewidget/no_internet_screen.dart';
import 'package:yml_ecommerce_test/basewidget/not_loggedin_widget.dart';
import 'package:yml_ecommerce_test/features/chat/widget/chat_item_widget.dart';
import 'package:yml_ecommerce_test/features/chat/widget/chat_type_button.dart';
import 'package:yml_ecommerce_test/features/chat/widget/inbox_shimmer.dart';
import 'package:yml_ecommerce_test/features/chat/widget/search_inbox_widget.dart';
import 'package:yml_ecommerce_test/features/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';


class InboxScreen extends StatefulWidget {
  final bool isBackButtonExist;
  const InboxScreen({super.key, this.isBackButtonExist = true});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {

  TextEditingController searchController = TextEditingController();

  late bool isGuestMode;
  @override
  void initState() {

    isGuestMode = !Provider.of<AuthController>(context, listen: false).isLoggedIn();
      if(!isGuestMode) {
        Provider.of<ChatProvider>(context, listen: false).getChatList(context, 1, reload: false);
      }

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return PopScope(canPop: false,
      onPopInvoked: (val) async{
        if(Navigator.of(context).canPop()){
          Navigator.of(context).pop();
        }else{
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => const DashBoardScreen()));

        }

        return;
      },
      child: Scaffold(
        appBar: CustomAppBar(title: getTranslated('inbox', context), isBackButtonExist: widget.isBackButtonExist,
        onBackPressed: (){
          if(Navigator.of(context).canPop()){
            Navigator.of(context).pop();
          }else{
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => const DashBoardScreen()));

          }
        },),
        body: Column(children: [
          if(!isGuestMode)
          Consumer<ChatProvider>(
            builder: (context, chat, _) {
              return Padding(padding: const EdgeInsets.fromLTRB( Dimensions.homePagePadding, Dimensions.paddingSizeSmall, Dimensions.homePagePadding, 0),
                child: SearchInboxWidget(
                  hintText: getTranslated('search', context),
                ));
            }
          ),

            if(!isGuestMode)
          Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall),
            child: Row(children: [
              ChatTypeButton(text: getTranslated('seller', context), index: 0),
              ChatTypeButton(text: getTranslated('delivery-man', context), index: 1)])),

          Expanded(
              child: isGuestMode ? const NotLoggedInWidget() :  RefreshIndicator(
                onRefresh: () async {
                  searchController.clear();
                  await Provider.of<ChatProvider>(context, listen: false).getChatList(context, 1);
                },
                child: Consumer<ChatProvider>(
                  builder: (context, chatProvider, child) {
                    return chatProvider.chatModel != null? (chatProvider.chatModel!.chat != null && chatProvider.chatModel!.chat!.isNotEmpty )?
                    ListView.builder(
                      itemCount: chatProvider.chatModel?.chat?.length,
                      padding: const EdgeInsets.all(0),
                      itemBuilder: (context, index) {
                        return ChatItemWidget(chat: chatProvider.chatModel!.chat![index], chatProvider: chatProvider);
                      },
                    ) : const NoInternetOrDataScreen(isNoInternet: false, message: 'no_conversion', icon: Images.noInbox,): const InboxShimmer();
                  },
                ),
              ),
            ),
        ]),
      ),
    );
  }
}



