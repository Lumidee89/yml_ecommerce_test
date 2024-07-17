import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/features/support/provider/support_ticket_provider.dart';
import 'package:yml_ecommerce_test/utill/custom_themes.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:provider/provider.dart';

class PriorityBottomSheet extends StatelessWidget {
  const PriorityBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SupportTicketProvider>(
        builder: (context, supportTicketProvider, child) {
          return Container(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(color: Theme.of(context).cardColor,
                borderRadius:  const BorderRadius.vertical(top: Radius.circular(Dimensions.paddingSizeDefault))),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 40,height: 5,decoration: BoxDecoration(color: Theme.of(context).hintColor.withOpacity(.5),
                  borderRadius: BorderRadius.circular(20)),),
              const SizedBox(height: 20,),
              ListView.builder(
                  itemCount: supportTicketProvider.priority.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index){
                    return InkWell(onTap: (){
                      Navigator.of(context).pop();
                        supportTicketProvider.setSelectedPriority(index);
                      },
                      child: Container(decoration: BoxDecoration(
                          color: supportTicketProvider.selectedPriorityIndex == index? Theme.of(context).primaryColor.withOpacity(.1): Theme.of(context).cardColor),
                        child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          child: Row(children: [
                            Padding(padding: EdgeInsets.symmetric(horizontal:supportTicketProvider.selectedPriorityIndex == index? Dimensions.paddingSizeSmall:0),
                              child: Text(getTranslated(supportTicketProvider.priority[index], context)??'',
                                style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault,
                                    color: supportTicketProvider.selectedPriorityIndex == index? Theme.of(context).primaryColor: Theme.of(context).textTheme.bodyLarge?.color),),),
                          ],
                          ),
                        ),
                      ),
                    );
                  }),
            ],
            ),
          );
        }
    );
  }
}
