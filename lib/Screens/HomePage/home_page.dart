import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:sanaa/CommonFiles/Model/products_model.dart';
import 'package:sanaa/CommonFiles/common_variables.dart';
import 'package:sanaa/CommonFiles/cubit/common_cubit.dart';
import 'package:sanaa/CommonFiles/image_file.dart';
import 'package:sanaa/CommonWidgets/banner_widget.dart';
import 'package:sanaa/CommonWidgets/category_widget.dart';
import 'package:sanaa/CommonWidgets/customer_review_widget.dart';
import 'package:sanaa/CommonWidgets/exciting_offers_widget.dart';
import 'package:sanaa/CommonWidgets/header_widget.dart';
import 'package:sanaa/CommonWidgets/popular_item_widget.dart';
import 'package:sanaa/CommonWidgets/recommended_widget.dart';
import 'package:sanaa/CommonWidgets/shops_widget.dart';
import 'package:sanaa/Screens/HomePage/Model/banner_model.dart';
import 'package:sanaa/Screens/HomePage/Model/main_category_model.dart';
import 'package:sanaa/Screens/HomePage/Model/offers_model.dart';
import 'package:sanaa/Screens/HomePage/Model/shop_model.dart';
import 'package:sanaa/Screens/HomePage/cubit/home_cubit.dart';
import 'package:sanaa/Screens/HomePage/cubit/home_state.dart';
import 'package:sanaa/SharedPrefrence/shared_prefrence.dart';
import '../../CommonFiles/common_function.dart';
import '../../CommonFiles/text_style.dart';
import '../../Navigation/navigation_service.dart';
import '../../main.dart';
import '../Account/Model/user_detail_model.dart';
import 'Model/testimonial_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late HomeCubit _homeCubit;
  List<BannerData> bannerData = [];
  List<MainCategoryData> mainCategories = [];
  List<OfferData> offers = [];
  List<ShopData> shops = [];
  List<ProductData> popularProduct = [];
  List<ProductData> recommendedProduct = [];
  List<Testimonial> _testimonials = [];
  UserDetail? userDetail;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _homeCubit = BlocProvider.of<HomeCubit>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // This function will be called after the widget build is complete
      getBanners();
      getCategories();
      getOffers();
      getShops();
      getPopularProducts();
      getRecommendedProducts();
      _getProfileData();
      _getTestimonials();

      Future.microtask(() {
        networkStatus.addListener(() {
          print("::::::::::: ${networkStatus.isOnline}");
          if (!networkStatus.isOnline) {
            print("inside>>>>>>>>>>>");
            showNoInternetAlert(context);
          }
        });
      });
    });
  }

  getBanners() async {
    await _homeCubit.getBanners();
  }

  getCategories() async {
    await _homeCubit.getMainCategories();
  }

  getOffers() async {
    await _homeCubit.getOffers();
  }

  getShops() async {
    await _homeCubit.getShops();
  }

  getPopularProducts() async {
    await _homeCubit.getPopularProducts();
  }

  getRecommendedProducts() async {
    await _homeCubit.getRecommendedProducts();
  }

  _getProfileData() async {
    final detail = await _homeCubit.getSavedUserDetail();
    print(detail);
    if (detail == null) {
      await _homeCubit.getUserDetails();
    } else {
      setState(() {
        userDetail = detail;
      });
    }
  }

  _getTestimonials() async {
    await _homeCubit.getTestimonials();
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Logout",
            style: FontStyles.getStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            AppLocalizations.of(context)?.areYouSureYouWantToLogout ?? "Are you sure you want to logout?",
            style: FontStyles.getStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                "Cancel",
                style: FontStyles.getStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text(
                "Logout",
                style: FontStyles.getStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                // Handle navigation
                await SharedPreferencesHelper.remove('token');
                await SharedPreferencesHelper.remove('user_detail');
                NavigationService.navigateAndClearStack('/onBoard');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) async {
        if (state is HomeBannerSuccess) {
          setState(() {
            bannerData = state.bannerData;
          });
        } else if (state is MainCategorySuccess) {
          setState(() {
            mainCategories = state.categoryData;
          });
        } else if (state is OffersSuccess) {
          setState(() {
            offers = state.offerData;
          });
        } else if (state is ShopsSuccess) {
          setState(() {
            shops = state.shopsData;
          });
        } else if (state is RecommendedProductSuccess) {
          setState(() {
            recommendedProduct = state.recommendedProducts;
          });
        } else if (state is PopularProductSuccess) {
          setState(() {
            popularProduct = state.popularProducts;
          });
        } else if (state is ProfileSuccess) {
          if (state.userDetail != null) {
            await _homeCubit.saveUserDetail(state.userDetail!);
            userDetail = state.userDetail;
          }
        } else if (state is ProfileFailed) {
          print("Profile load err:: ${state.error}");
        } else if (state is TestimonialsSuccess) {
          setState(() {
            _testimonials = state.testimonials;
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          key: _scaffoldKey,
          endDrawer: Drawer(
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: (!isUserLoggedIn())
                  ? Center(
                    child:
                      ElevatedButton(
                          onPressed: () {
                            NavigationService.navigateTo('/loginPage',arguments: true);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),
                          child: Text(
                            'Login',
                            style: FontStyles.getStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),


                  )
                  : ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        DrawerHeader(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _scaffoldKey.currentState?.closeEndDrawer();
                                },
                                child: Image.asset(
                                  back,
                                  width: 36,
                                  height: 36,
                                ),
                              ),
                              SizedBox(height: 30),
                              if (!isUserLoggedIn())
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                  ),
                                  child: Text(
                                    'Login',
                                    style: FontStyles.getStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              if (isUserLoggedIn())
                                InkWell(
                                  onTap: (){
                                    Navigator.pop(context);
                                    NavigationService.navigateTo('/profilePage');
                                  },
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 66,
                                        height: 66,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(33),
                                          child: Image.network(
                                            userDetail?.profilePictureUrl ?? dummyImageUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          userDetail?.name ?? '',
                                          style: FontStyles.getStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Icon(Icons.arrow_forward_ios_rounded)
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ),
                        ListTile(
                          leading: Image.asset(
                            userCircle,
                            width: 22,
                            height: 22,
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 20,
                          ),
                          title: Text(
                            AppLocalizations.of(context)?.personalInfo ?? 'Personal Information',
                            style: FontStyles.getStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () {
                            // Handle navigation
                            Navigator.pop(context);
                            NavigationService.navigateTo('/profileDetail');
                          },
                        ),
                        Divider(),
                        ListTile(
                          leading: Image.asset(
                            location,
                            width: 22,
                            height: 22,
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 20,
                          ),
                          title: Text(
                            AppLocalizations.of(context)?.deliveryAddress ?? 'Delivery Address',
                            style: FontStyles.getStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () {
                            // Handle navigation
                            Navigator.pop(context);
                            NavigationService.navigateTo('/deliveryAddress');
                          },
                        ),
                        Divider(),
                        ListTile(
                          leading: Image.asset(
                            box,
                            width: 22,
                            height: 22,
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 20,
                          ),
                          title: Text(
                            AppLocalizations.of(context)?.orders ?? 'Orders',
                            style: FontStyles.getStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () {
                            // Handle navigation
                            Navigator.pop(context);
                            NavigationService.navigateTo('/orderList',arguments: false);
                          },
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.logout),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 20,
                          ),
                          title: Text(
                            AppLocalizations.of(context)?.logout ?? 'LOGOUT',
                            style: FontStyles.getStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () async {
                            _showLogoutDialog(context);
                          },
                        ),
                      ],
                    ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  HeaderWidget(
                    scaffoldKey: _scaffoldKey,
                    userDetail: userDetail,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (bannerData.isNotEmpty)
                    SizedBox(
                      height: 160,
                      child: BannerWidget(
                        banners: bannerData,
                        paddingHorizontal: 8,
                      ),
                    ),
                  if (bannerData.isEmpty) const CircularProgressIndicator(),
                  const SizedBox(
                    height: 20,
                  ),
                  if (mainCategories.isNotEmpty)
                    SizedBox(
                      height: 130,
                      child: CategoryWidget(
                        categoryData: mainCategories,
                      ),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (recommendedProduct.length > 0)
                    RecommendedWidget(
                      products: recommendedProduct,
                      onTapLikeIcon: (ProductData product) {
                        final param = {"product_id": product.id};
                        setState(() {
                          product.isInWishlist = true;
                        });
                        context.read<CommonCubit>().addProductToWishList(param);
                      },
                      onTapCartIcon: (ProductData product) {
                        final param = {"product_variant_id": product.product_variant_id ?? ''};
                        context.read<CommonCubit>().addProductToCart(param);
                      },
                    ),
                  if (recommendedProduct.length > 0)
                    const SizedBox(
                      height: 20,
                    ),
                  if (offers.isNotEmpty)
                    ExcitingOffersWidget(
                      offers: offers,
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (shops.isNotEmpty)
                    ShopsWidget(
                      shops: shops,
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (popularProduct.length > 0)
                    PopularItemWidget(
                      products: popularProduct,
                      onTapLikeIcon: (ProductData product) {
                        final param = {"product_id": product.id};
                        setState(() {
                          product.isInWishlist = true;
                        });
                        context.read<CommonCubit>().addProductToWishList(param);
                      },
                      onTapCartIcon: (ProductData product) {
                        final param = {"product_variant_id": product.product_variant_id ?? ''};
                        context.read<CommonCubit>().addProductToCart(param);
                      },
                    ),
                  if (popularProduct.length > 0)
                    const SizedBox(
                      height: 20,
                    ),
                  if (_testimonials.length > 0)
                    CustomerReviewWidget(
                      testimonials: _testimonials,
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
