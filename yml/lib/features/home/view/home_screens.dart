import 'package:flutter/material.dart';
import 'package:yml_ecommerce_test/helper/product_type.dart';
import 'package:yml_ecommerce_test/localization/language_constrants.dart';
import 'package:yml_ecommerce_test/main.dart';
import 'package:yml_ecommerce_test/features/auth/controllers/auth_controller.dart';
import 'package:yml_ecommerce_test/features/banner/controllers/banner_controller.dart';
import 'package:yml_ecommerce_test/features/brand/controllers/brand_controller.dart';
import 'package:yml_ecommerce_test/features/cart/controllers/cart_controller.dart';
import 'package:yml_ecommerce_test/features/category/controllers/category_controller.dart';
import 'package:yml_ecommerce_test/features/deal/provider/featured_deal_provider.dart';
import 'package:yml_ecommerce_test/features/deal/provider/flash_deal_provider.dart';
import 'package:yml_ecommerce_test/features/product/provider/home_category_product_provider.dart';
import 'package:yml_ecommerce_test/features/notification/provider/notification_provider.dart';
import 'package:yml_ecommerce_test/features/product/provider/product_provider.dart';
import 'package:yml_ecommerce_test/features/profile/provider/profile_provider.dart';
import 'package:yml_ecommerce_test/features/splash/provider/splash_provider.dart';
import 'package:yml_ecommerce_test/theme/provider/theme_provider.dart';
import 'package:yml_ecommerce_test/features/shop/provider/top_seller_provider.dart';
import 'package:yml_ecommerce_test/features/wishlist/provider/wishlist_provider.dart';
import 'package:yml_ecommerce_test/utill/custom_themes.dart';
import 'package:yml_ecommerce_test/utill/dimensions.dart';
import 'package:yml_ecommerce_test/utill/images.dart';
import 'package:yml_ecommerce_test/basewidget/title_row.dart';
import 'package:yml_ecommerce_test/features/deal/view/featured_deal_screen.dart';
import 'package:yml_ecommerce_test/features/home/shimmer/featured_product_shimmer.dart';
import 'package:yml_ecommerce_test/features/home/widget/announcement.dart';
import 'package:yml_ecommerce_test/features/home/widget/aster_theme/find_what_you_need_shimmer.dart';
import 'package:yml_ecommerce_test/features/banner/widgets/banners_view.dart';
import 'package:yml_ecommerce_test/features/home/widget/cart_widget_home_page.dart';
import 'package:yml_ecommerce_test/features/deal/widget/featured_deal_view.dart';
import 'package:yml_ecommerce_test/features/product/widget/featured_product_view.dart';
import 'package:yml_ecommerce_test/features/home/shimmer/flash_deal_shimmer.dart';
import 'package:yml_ecommerce_test/features/deal/widget/flash_deals_view.dart';
import 'package:yml_ecommerce_test/features/banner/widgets/single_banner.dart';
import 'package:yml_ecommerce_test/features/product/widget/home_category_product_view.dart';
import 'package:yml_ecommerce_test/features/product/widget/latest_product_view.dart';
import 'package:yml_ecommerce_test/features/product/widget/products_view.dart';
import 'package:yml_ecommerce_test/features/deal/view/flash_deal_screen.dart';
import 'package:yml_ecommerce_test/features/product/widget/recommended_product_view.dart';
import 'package:yml_ecommerce_test/features/home/widget/search_widget_home_page.dart';
import 'package:yml_ecommerce_test/features/shop/widget/top_seller_view.dart';
import 'package:yml_ecommerce_test/features/product/view/view_all_product_screen.dart';
import 'package:yml_ecommerce_test/features/search/search_screen.dart';
import 'package:yml_ecommerce_test/features/shop/view/all_shop_screen.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  Future<void> _loadData(bool reload) async {
    await Provider.of<BannerController>(Get.context!, listen: false)
        .getBannerList(reload);
    await Provider.of<CategoryController>(Get.context!, listen: false)
        .getCategoryList(reload);
    await Provider.of<HomeCategoryProductProvider>(Get.context!, listen: false)
        .getHomeCategoryProductList(reload);
    await Provider.of<TopSellerProvider>(Get.context!, listen: false)
        .getTopSellerList(reload);
    await Provider.of<BrandController>(Get.context!, listen: false)
        .getBrandList(reload);
    await Provider.of<ProductProvider>(Get.context!, listen: false)
        .getLatestProductList(1, reload: reload);
    await Provider.of<ProductProvider>(Get.context!, listen: false)
        .getFeaturedProductList('1', reload: reload);
    await Provider.of<FeaturedDealProvider>(Get.context!, listen: false)
        .getFeaturedDealList(reload);
    await Provider.of<ProductProvider>(Get.context!, listen: false)
        .getLProductList('1', reload: reload);
    await Provider.of<ProductProvider>(Get.context!, listen: false)
        .getRecommendedProduct();
    await Provider.of<CartController>(Get.context!, listen: false)
        .getCartDataAPI(Get.context!);
    await Provider.of<NotificationProvider>(Get.context!, listen: false)
        .getNotificationList(1);
    if (Provider.of<AuthController>(Get.context!, listen: false).isLoggedIn()) {
      await Provider.of<ProfileProvider>(Get.context!, listen: false)
          .getUserInfo(Get.context!);
      await Provider.of<WishListProvider>(Get.context!, listen: false)
          .getWishList();
    }
  }

  void passData(int index, String title) {
    index = index;
    title = title;
  }

  bool singleVendor = false;
  @override
  void initState() {
    super.initState();
    singleVendor = Provider.of<SplashProvider>(context, listen: false)
            .configModel!
            .businessMode ==
        "single";
    Provider.of<FlashDealProvider>(context, listen: false)
        .getMegaDealList(true, true);
    _loadData(false);
  }

  @override
  Widget build(BuildContext context) {
    List<String?> types = [
      getTranslated('new_arrival', context),
      getTranslated('top_product', context),
      getTranslated('best_selling', context),
      getTranslated('discounted_product', context)
    ];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await _loadData(true);
            await Provider.of<FlashDealProvider>(Get.context!, listen: false)
                .getMegaDealList(true, false);
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                floating: true,
                elevation: 0,
                centerTitle: false,
                automaticallyImplyLeading: false,
                backgroundColor: Theme.of(context).highlightColor,
                title: Image.asset(Images.logoWithNameImage, height: 35),
                actions: const [
                  CartWidgetHomePage(),
                ],
              ),
              SliverToBoxAdapter(
                child: Provider.of<SplashProvider>(context, listen: false)
                            .configModel!
                            .announcement!
                            .status ==
                        '1'
                    ? Consumer<SplashProvider>(
                        builder: (context, announcement, _) {
                          return (announcement.configModel!.announcement!
                                          .announcement !=
                                      null &&
                                  announcement.onOff)
                              ? AnnouncementScreen(
                                  announcement:
                                      announcement.configModel!.announcement)
                              : const SizedBox();
                        },
                      )
                    : const SizedBox(),
              ),
              SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverDelegate(
                      child: InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const SearchScreen())),
                          child: const SearchWidgetHomePage()))),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BannersView(),
                    const SizedBox(height: Dimensions.homePagePadding),

                    // Flash Deal
                    Consumer<FlashDealProvider>(
                      builder: (context, megaDeal, child) {
                        return megaDeal.flashDeal != null
                            ? megaDeal.flashDealList.isNotEmpty
                                ? Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            Dimensions.homePagePadding,
                                            Dimensions.paddingSizeSmall,
                                            Dimensions.paddingSizeDefault,
                                            Dimensions
                                                .paddingSizeExtraExtraSmall),
                                        child: TitleRow(
                                            title: getTranslated(
                                                'flash_deal', context),
                                            eventDuration:
                                                megaDeal.flashDeal != null
                                                    ? megaDeal.duration
                                                    : null,
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          const FlashDealScreen()));
                                            },
                                            isFlash: true),
                                      ),
                                      const SizedBox(
                                          height: Dimensions.paddingSizeSmall),
                                      Text(
                                          getTranslated(
                                                  'hurry_up_the_offer_is_limited_grab_while_it_lasts',
                                                  context) ??
                                              '',
                                          style: textRegular.copyWith(
                                              color: Provider.of<ThemeProvider>(
                                                          context,
                                                          listen: false)
                                                      .darkTheme
                                                  ? Theme.of(context).hintColor
                                                  : Theme.of(context)
                                                      .primaryColor)),
                                      const SizedBox(
                                          height:
                                              Dimensions.paddingSizeDefault),
                                      const SizedBox(
                                          height: 350,
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: Dimensions
                                                      .homePagePadding),
                                              child: FlashDealsView())),
                                    ],
                                  )
                                : const SizedBox.shrink()
                            : const FlashDealShimmer();
                      },
                    ),

                    // Featured Deal

                    Consumer<FeaturedDealProvider>(
                      builder: (context, featuredDealProvider, child) {
                        return featuredDealProvider.featuredDealProductList !=
                                null
                            ? featuredDealProvider
                                    .featuredDealProductList!.isNotEmpty
                                ? Stack(children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 150,
                                        color: Provider.of<ThemeProvider>(
                                                    context,
                                                    listen: false)
                                                .darkTheme
                                            ? Theme.of(context)
                                                .primaryColor
                                                .withOpacity(.20)
                                            : Theme.of(context)
                                                .primaryColor
                                                .withOpacity(.125)),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: Dimensions.homePagePadding),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: Dimensions
                                                          .paddingSizeDefault),
                                              child: TitleRow(
                                                title:
                                                    '${getTranslated('featured_deals', context)}',
                                                onTap: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            const FeaturedDealScreen())),
                                              ),
                                            ),
                                            const FeaturedDealsView(),
                                          ],
                                        )),
                                  ])
                                : const SizedBox.shrink()
                            : const FindWhatYouNeedShimmer();
                      },
                    ),

                    //footer banner
                    Consumer<BannerController>(
                        builder: (context, footerBannerProvider, child) {
                      return footerBannerProvider.footerBannerList != null &&
                              footerBannerProvider.footerBannerList!.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  bottom: Dimensions.homePagePadding,
                                  left: Dimensions.homePagePadding,
                                  right: Dimensions.homePagePadding),
                              child: SingleBannersView(
                                  bannerModel: footerBannerProvider
                                      .footerBannerList?[0]))
                          : const SizedBox();
                    }),

                    // Featured Products
                    Consumer<ProductProvider>(builder: (context, featured, _) {
                      return featured.featuredProductList != null
                          ? featured.featuredProductList!.isNotEmpty
                              ? Stack(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 50, bottom: 25),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              50,
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius
                                                  .only(
                                                  topLeft: Radius.circular(
                                                      Dimensions
                                                          .paddingSizeDefault),
                                                  bottomLeft: Radius.circular(
                                                      Dimensions
                                                          .paddingSizeDefault)),
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondaryContainer),
                                        )),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: Dimensions
                                                  .paddingSizeExtraSmall,
                                              vertical: Dimensions
                                                  .paddingSizeExtraSmall),
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20,
                                                  left: 50,
                                                  bottom: Dimensions
                                                      .paddingSizeSmall),
                                              child: TitleRow(
                                                  title: getTranslated(
                                                      'featured_products',
                                                      context),
                                                  onTap: () => Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              AllProductScreen(
                                                                  productType:
                                                                      ProductType
                                                                          .featuredProduct))))),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom:
                                                  Dimensions.homePagePadding),
                                          child: FeaturedProductView(
                                            scrollController: _scrollController,
                                            isHome: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : const SizedBox()
                          : const FeaturedProductShimmer();
                    }),

                    //top seller
                    singleVendor
                        ? const SizedBox()
                        : Consumer<TopSellerProvider>(
                            builder: (context, topSellerProvider, child) {
                            return (topSellerProvider.topSellerList != null &&
                                    topSellerProvider.topSellerList!.isNotEmpty)
                                ? TitleRow(
                                    title: getTranslated('top_seller', context),
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const AllTopSellerScreen(
                                                  topSeller: null,
                                                  title: 'top_seller',
                                                ))))
                                : const SizedBox();
                          }),
                    singleVendor
                        ? const SizedBox(height: 0)
                        : const SizedBox(height: Dimensions.paddingSizeSmall),
                    singleVendor
                        ? const SizedBox()
                        : Consumer<TopSellerProvider>(
                            builder: (context, topSellerProvider, child) {
                            return (topSellerProvider.topSellerList != null &&
                                    topSellerProvider.topSellerList!.isNotEmpty)
                                ? const Padding(
                                    padding: EdgeInsets.only(
                                        bottom: Dimensions.homePagePadding),
                                    child: SizedBox(
                                        height: 165,
                                        child: TopSellerView(isHomePage: true)))
                                : const SizedBox();
                          }),

                    const Padding(
                        padding:
                            EdgeInsets.only(bottom: Dimensions.homePagePadding),
                        child: RecommendedProductView()),

                    // Latest Products
                    const Padding(
                        padding: EdgeInsets.only(
                            bottom: Dimensions.paddingSizeSmall),
                        child: LatestProductView()),

                    // // Brand
                    // Provider.of<SplashProvider>(context, listen: false).configModel!.brandSetting == "1"?
                    // Consumer<BrandController>(
                    //   builder: (context, brandController,_) {
                    //     return (brandController.brandList != null && brandController.brandList!.isNotEmpty)?
                    //     TitleRow(title: getTranslated('brand', context),
                    //         onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AllBrandScreen()))): const SizedBox();
                    //   }
                    // ):const SizedBox(),
                    // SizedBox(height: Provider.of<SplashProvider>(context, listen: false).configModel!.brandSetting == "1"?Dimensions.paddingSizeSmall: 0),
                    // Provider.of<SplashProvider>(context, listen: false).configModel!.brandSetting == "1"?
                    // const BrandView(isHomePage: true) : const SizedBox(),

                    //Home category
                    const HomeCategoryProductView(isHomePage: true),
                    const SizedBox(height: Dimensions.homePagePadding),

                    //footer banner
                    Consumer<BannerController>(
                        builder: (context, footerBannerProvider, child) {
                      return footerBannerProvider.footerBannerList != null &&
                              footerBannerProvider.footerBannerList!.length > 1
                          ? SingleBannersView(
                              bannerModel:
                                  footerBannerProvider.footerBannerList?[1])
                          : const SizedBox();
                    }),
                    const SizedBox(height: Dimensions.homePagePadding),

                    //Category filter
                    Consumer<ProductProvider>(
                        builder: (ctx, prodProvider, child) {
                      return Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  Dimensions.paddingSizeDefault,
                                  0,
                                  Dimensions.paddingSizeSmall,
                                  0),
                              child: Row(children: [
                                Expanded(
                                    child: Text(
                                        prodProvider.title == 'xyz'
                                            ? getTranslated(
                                                'new_arrival', context)!
                                            : prodProvider.title!,
                                        style: titleHeader)),
                                prodProvider.latestProductList != null
                                    ? PopupMenuButton(
                                        itemBuilder: (context) {
                                          return [
                                            PopupMenuItem(
                                                value: ProductType.newArrival,
                                                textStyle: textRegular.copyWith(
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                                child: Text(getTranslated(
                                                    'new_arrival', context)!)),
                                            PopupMenuItem(
                                                value: ProductType.topProduct,
                                                textStyle: textRegular.copyWith(
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                                child: Text(getTranslated(
                                                    'top_product', context)!)),
                                            PopupMenuItem(
                                                value: ProductType.bestSelling,
                                                textStyle: textRegular.copyWith(
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                                child: Text(getTranslated(
                                                    'best_selling', context)!)),
                                            PopupMenuItem(
                                                value: ProductType
                                                    .discountedProduct,
                                                textStyle: textRegular.copyWith(
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                                child: Text(getTranslated(
                                                    'discounted_product',
                                                    context)!)),
                                          ];
                                        },
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.paddingSizeSmall)),
                                        child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                Dimensions
                                                    .paddingSizeExtraSmall,
                                                Dimensions.paddingSizeSmall,
                                                Dimensions
                                                    .paddingSizeExtraSmall,
                                                Dimensions.paddingSizeSmall),
                                            child: Image.asset(Images.dropdown,
                                                scale: 3)),
                                        onSelected: (dynamic value) {
                                          if (value == ProductType.newArrival) {
                                            Provider.of<ProductProvider>(
                                                    context,
                                                    listen: false)
                                                .changeTypeOfProduct(
                                                    value, types[0]);
                                          } else if (value ==
                                              ProductType.topProduct) {
                                            Provider.of<ProductProvider>(
                                                    context,
                                                    listen: false)
                                                .changeTypeOfProduct(
                                                    value, types[1]);
                                          } else if (value ==
                                              ProductType.bestSelling) {
                                            Provider.of<ProductProvider>(
                                                    context,
                                                    listen: false)
                                                .changeTypeOfProduct(
                                                    value, types[2]);
                                          } else if (value ==
                                              ProductType.discountedProduct) {
                                            Provider.of<ProductProvider>(
                                                    context,
                                                    listen: false)
                                                .changeTypeOfProduct(
                                                    value, types[3]);
                                          }

                                          ProductView(
                                              isHomePage: false,
                                              productType: value,
                                              scrollController:
                                                  _scrollController);
                                          Provider.of<ProductProvider>(context,
                                                  listen: false)
                                              .getLatestProductList(1,
                                                  reload: true);
                                        })
                                    : const SizedBox(),
                              ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.homePagePadding),
                              child: ProductView(
                                  isHomePage: false,
                                  productType: ProductType.newArrival,
                                  scrollController: _scrollController),
                            ),
                            const SizedBox(height: Dimensions.homePagePadding),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  double height;
  SliverDelegate({required this.child, this.height = 70});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != height ||
        oldDelegate.minExtent != height ||
        child != oldDelegate.child;
  }
}
