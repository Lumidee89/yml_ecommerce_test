import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/features/dashboard/dashboard_screen.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/features/onboarding/provider/onboarding_provider.dart';
import 'package:yml_ecommerce_test/features/splash/provider/splash_provider.dart';
import 'package:yml_ecommerce_test/utill/custom_themes.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:provider/provider.dart';

class OnBoardingScreen extends StatelessWidget {
  final Color indicatorColor;
  final Color selectedIndicatorColor;
  OnBoardingScreen(
      {super.key,
      this.indicatorColor = Colors.grey,
      this.selectedIndicatorColor = Colors.black});
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    Provider.of<OnBoardingProvider>(context, listen: false)
        .initBoardingList(context);

    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Consumer<OnBoardingProvider>(
            builder: (context, onBoardingList, child) => ListView(
              children: [
                SizedBox(
                  height: height * 0.75,
                  child: PageView.builder(
                    itemCount: onBoardingList.onBoardingList.length,
                    controller: _pageController,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding:
                            const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image.asset(
                              onBoardingList.onBoardingList[index].imageUrl,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: Dimensions.paddingSizeDefault),
                              child: Text(
                                  onBoardingList.onBoardingList[index].title,
                                  style: titilliumBold.copyWith(fontSize: 18),
                                  textAlign: TextAlign.center),
                            ),
                            Text(
                                onBoardingList
                                    .onBoardingList[index].description,
                                textAlign: TextAlign.center,
                                style: titilliumRegular.copyWith(
                                    fontSize: Dimensions.fontSizeDefault)),
                            const SizedBox(
                                height: Dimensions.paddingSizeDefault),
                          ],
                        ),
                      );
                    },
                    onPageChanged: (index) {
                      onBoardingList.changeSelectIndex(index);
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
                  child: Stack(children: [
                    if (onBoardingList.onBoardingList.isNotEmpty)
                      Center(
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor.withOpacity(.6)),
                            value: (onBoardingList.selectedIndex + 1) /
                                onBoardingList.onBoardingList.length,
                            backgroundColor: Theme.of(context)
                                .primaryColor
                                .withOpacity(.125),
                          ),
                        ),
                      ),
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          if (onBoardingList.selectedIndex ==
                              onBoardingList.onBoardingList.length - 1) {
                            Provider.of<SplashProvider>(context, listen: false)
                                .disableIntro();
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const DashBoardScreen()));
                          } else {
                            _pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn);
                          }
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          margin: const EdgeInsets.only(top: 5),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            onBoardingList.selectedIndex ==
                                    onBoardingList.onBoardingList.length - 1
                                ? Icons.check
                                : Icons.navigate_next,
                            color: Theme.of(context).primaryColor,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ]),
                )
              ],
            ),
          ),
          Positioned(
              child: Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      Provider.of<SplashProvider>(context, listen: false)
                          .disableIntro();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const DashBoardScreen()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 50, horizontal: 20),
                      child: Text('${getTranslated('skip', context)}',
                          style: textMedium.copyWith(
                              color: Theme.of(context).primaryColor)),
                    ),
                  )))
        ],
      ),
    );
  }
}
