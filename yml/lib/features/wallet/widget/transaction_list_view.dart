import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/features/wallet/domain/model/transaction_model.dart';
import 'package:yml_ecommerce_test/features/wallet/provider/wallet_provider.dart';
import 'package:yml_ecommerce_test/utill/images.dart';
import 'package:yml_ecommerce_test/basewidget/no_internet_screen.dart';
import 'package:yml_ecommerce_test/features/home/shimmer/transaction_shimmer.dart';
import 'package:yml_ecommerce_test/features/wallet/widget/transaction_widget.dart';
import 'package:provider/provider.dart';

class TransactionListView extends StatelessWidget {
  final ScrollController? scrollController;
  const TransactionListView({super.key,  this.scrollController});

  @override
  Widget build(BuildContext context) {
    int offset = 1;
    scrollController?.addListener(() {
      if(scrollController!.position.maxScrollExtent == scrollController!.position.pixels
          && Provider.of<WalletTransactionProvider>(context, listen: false).transactionList.isNotEmpty
          && !Provider.of<WalletTransactionProvider>(context, listen: false).isLoading) {
        int? pageSize;
        pageSize = (Provider.of<WalletTransactionProvider>(context, listen: false).transactionPageSize! / 10).ceil();

        if(offset < pageSize) {
          offset++;
          if (kDebugMode) {
            print('end of the page');
          }
          Provider.of<WalletTransactionProvider>(context, listen: false).showBottomLoader();
         Provider.of<WalletTransactionProvider>(context, listen: false).getTransactionList(context, offset,Provider.of<WalletTransactionProvider>(context, listen: false).selectedFilterType, reload: false);
        }
      }

    });

    return Consumer<WalletTransactionProvider>(
      builder: (context, transactionProvider, child) {
        List<WalletTransactioList> transactionList;
        transactionList = transactionProvider.transactionList;

        return Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

          !transactionProvider.isLoading ? (transactionList.isNotEmpty) ?
          ListView.builder(shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: transactionList.length,
              itemBuilder: (ctx,index){
                return SizedBox(width: (MediaQuery.of(context).size.width/2)-20,
                    child: TransactionWidget(transactionModel: transactionList[index]));

              }): const NoInternetOrDataScreen(isNoInternet: false, message: 'no_transaction_history',icon: Images.noTransaction) :
          const TransactionShimmer()

        ]);
      },
    );
  }
}

