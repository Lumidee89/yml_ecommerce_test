import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/features/product/provider/search_provider.dart';
import 'package:yml_ecommerce_test/utill/custom_themes.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/utill/images.dart';
import 'package:yml_ecommerce_test/basewidget/show_custom_snakbar.dart';
import 'package:provider/provider.dart';
import 'package:substring_highlight/substring_highlight.dart';

class SearchSuggestion extends StatefulWidget{
  final bool fromCompare;
  final int? id;
  const SearchSuggestion({super.key,  this.fromCompare = false, this.id});
  @override
  State<SearchSuggestion> createState() => _SearchSuggestionState();
}

class _SearchSuggestionState extends State<SearchSuggestion> {
  @override
  Widget build(BuildContext context) {

    return Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
      child: Consumer<SearchProvider>(
        builder: (context, searchProvider, _) {
          return SizedBox(height: 56,
            child: Padding(padding: const EdgeInsets.only(bottom: 8.0),
              child: Autocomplete(

                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty || searchProvider.suggestionModel == null) {
                    return const Iterable<String>.empty();
                  } else {
                    return searchProvider.nameList.where((word) => word.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                  }
                },

                optionsViewBuilder: (context, Function(String) onSelected, options) {
                  return Material(
                    elevation: 0,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final option = options.elementAt(index);

                        return InkWell(onTap: (){
                            if(widget.fromCompare){
                              searchProvider.setSelectedProductId(index, widget.id);
                              Navigator.of(context).pop();
                            }else{
                              searchProvider.searchProduct(query : option.toString(), offset: 1);
                              onSelected(option.toString());
                            }
                          },
                          child: Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                            child: Column(children: [
                                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                                      child: Icon(Icons.history, color: Theme.of(context).hintColor,size: 20)),

                                  Expanded(child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                    child: SubstringHighlight(
                                      text: option.toString(),
                                      textStyle: textRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.5)),
                                      term: searchProvider.searchController.text,
                                      textStyleHighlight:  textBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeLarge),
                                    ),
                                  ),
                                  ),
                                  const SizedBox(width: Dimensions.paddingSizeSmall,)
                                ],
                                ),
                              const Divider(thickness: .125)
                              ],
                            ),
                          ),
                        );
                      },

                      itemCount: options.length,
                    ),
                  );
                },
                onSelected: (selectedString) {
                  if (kDebugMode) {
                    print(selectedString);
                  }
                },
                fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                  searchProvider.searchController = controller;

                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    onEditingComplete: onEditingComplete,
                    textInputAction: TextInputAction.search,
                    onFieldSubmitted: (value) {
                      if(controller.text.trim().isNotEmpty) {
                        Provider.of<SearchProvider>(context, listen: false).saveSearchAddress( controller.text.toString());
                        Provider.of<SearchProvider>(context, listen: false).searchProduct( query : controller.text.toString(), offset: 1);
                      }else{
                        showCustomSnackBar(getTranslated('enter_somethings', context), context);

                      }
                    },
                    onChanged: (val){
                      if(val.isNotEmpty){
                        searchProvider.getSuggestionProductName(searchProvider.searchController.text.trim());
                      }
                    },

                    decoration: InputDecoration(
                      isDense: true,

                      contentPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                        borderSide: BorderSide(color: Colors.grey[300]!)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                        borderSide: BorderSide(color: Colors.grey[300]!)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                        borderSide: BorderSide(color: Colors.grey[300]!)),
                      hintText: "Search Something",
                     suffixIcon: SizedBox(width: controller.text.isNotEmpty? 70 : 50,
                       child: Row(
                         children: [
                           if(controller.text.isNotEmpty)
                           InkWell(onTap: (){
                             setState(() {
                               controller.clear();
                             });
                           },
                               child: const Icon(Icons.clear, size: 20,)),
                           InkWell(onTap: (){
                               if(controller.text.trim().isNotEmpty) {
                                 Provider.of<SearchProvider>(context, listen: false).saveSearchAddress( controller.text.toString());
                                 Provider.of<SearchProvider>(context, listen: false).searchProduct( query : controller.text.toString(), offset: 1);
                               }else{
                                 showCustomSnackBar(getTranslated('enter_somethings', context), context);

                               }
                             },
                             child: Padding(padding: const EdgeInsets.all(5),
                               child: Container(width: 40, height: 50,decoration: BoxDecoration(color: Theme.of(context).primaryColor,
                                   borderRadius: const BorderRadius.all( Radius.circular(Dimensions.paddingSizeSmall))),
                                   child: SizedBox(width : 18,height: 18, child: Padding(
                                     padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                     child: Image.asset(Images.search, color: Colors.white),
                                   ))),
                             ),
                           ),
                         ],
                       ),
                     )
                    ),
                  );
                },
              ),
            ),
          );
        }
      ),
    );
  }
}
