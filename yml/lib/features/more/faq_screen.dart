import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/features/splash/provider/splash_provider.dart';
import 'package:yml_ecommerce_test/utill/color_resources.dart';
import 'package:yml_ecommerce_test/utill/custom_themes.dart';
import 'package:yml_ecommerce_test/basewidget/custom_app_bar.dart';
import 'package:yml_ecommerce_test/basewidget/no_internet_screen.dart';
import 'package:provider/provider.dart';
class FaqScreen extends StatefulWidget {
  final String? title;
  const FaqScreen({super.key, required this.title});

  @override
  FaqScreenState createState() => FaqScreenState();
}

class FaqScreenState extends State<FaqScreen> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        CustomAppBar(title: widget.title),

        Provider.of<SplashProvider>(context).configModel!.faq != null && Provider.of<SplashProvider>(context).configModel!.faq!.isNotEmpty? Expanded(
          child: ListView.builder(
              itemCount: Provider.of<SplashProvider>(context).configModel!.faq!.length,
              itemBuilder: (ctx, index){
                return  Consumer<SplashProvider>(
                  builder: (ctx, faq, child){
                    return Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(child: ExpansionTile(iconColor: Theme.of(context).primaryColor,title: Text(faq.configModel!.faq![index].question!,
                                style: robotoBold.copyWith(color: ColorResources.getTextTitle(context))),
                              leading: Icon(Icons.collections_bookmark_outlined,color:ColorResources.getTextTitle(context)),
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(faq.configModel!.faq![index].answer!,style: textRegular, textAlign: TextAlign.justify,),
                                )
                              ],)),
                          ],
                        ),

                      ],);
                  },
                );
              }),
        ): const NoInternetOrDataScreen(isNoInternet: false)

      ],),
    );
  }
}
