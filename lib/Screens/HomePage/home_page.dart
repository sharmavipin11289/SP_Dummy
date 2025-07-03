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
import 'package:sanaa/Screens/HomePage/Model/advertisment_model.dart';
import 'package:sanaa/Screens/HomePage/Model/banner_model.dart';
import 'package:sanaa/Screens/HomePage/Model/main_category_model.dart';
import 'package:sanaa/Screens/HomePage/Model/offers_model.dart';
import 'package:sanaa/Screens/HomePage/Model/shop_model.dart';
import 'package:sanaa/Screens/HomePage/cubit/home_cubit.dart';
import 'package:sanaa/Screens/HomePage/cubit/home_state.dart';
import 'package:sanaa/SharedPrefrence/shared_prefrence.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../CommonFiles/common_function.dart';
import '../../CommonFiles/text_style.dart';
import '../../Navigation/navigation_service.dart';
import '../../firebase_messaging/firebase_notification.dart';
import '../../main.dart';
import '../Account/Model/user_detail_model.dart';
import '../LoginPage/auth_service.dart';
import 'Model/testimonial_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final HomeCubit _homeCubit;
  late final WebViewController _controller;
  final ValueNotifier<bool> _isMounted = ValueNotifier<bool>(true);
  List<BannerData> bannerData = [];
  List<MainCategoryData> mainCategories = [];
  List<OfferData> offers = [];
  List<ShopData> shops = [];
  List<ProductData> popularProduct = [];
  List<ProductData> recommendedProduct = [];
  List<Testimonial> _testimonials = [];
  List<AdvertismentData> _advertismentData = [];
  UserDetail? userDetail;

  @override
  void initState() {
    super.initState();
    _homeCubit = BlocProvider.of<HomeCubit>(context);
    _initializeWebView();
    _initializeData();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (_isMounted.value) {
              debugPrint('WebView loading: $progress%');
            }
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            if (_isMounted.value) {
              debugPrint('WebView error: $error');
            }
          },
        ),
      );
  }

  void _initializeData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isMounted.value) return;

      // Fetch data
      _homeCubit.getBanners();
      _homeCubit.getMainCategories();
      _homeCubit.getOffers();
      _homeCubit.getShops();
      _homeCubit.getPopularProducts();
      _homeCubit.getRecommendedProducts();
      _getProfileData();
      _homeCubit.getTestimonials();
      _homeCubit.getAdvertismentData();

      // Network status listener
      networkStatus.addListener(_networkListener);
    });
  }

  void _networkListener() {
    if (!_isMounted.value) return;
    if (!networkStatus.isOnline) {
      showNoInternetAlert(context);
    }
  }

  void loadAd(String? jsonData) {
    if (!_isMounted.value || jsonData == null) return;

    final String htmlContent = '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <style>
        body { margin: 0; padding: 0; }
        .adsbygoogle { width: 100%; height: auto; }
      </style>
    </head>
    <body>
      $jsonData
    </body>
    </html>
    ''';

    _controller.loadHtmlString(htmlContent);
  }

  Future<void> _getProfileData() async {
    if (!_isMounted.value) return;

    final detail = await _homeCubit.getSavedUserDetail();
    if (mounted && detail != null) {
      setState(() {
        userDetail = detail;
      });
    } else {
      await _homeCubit.getUserDetails();
    }
  }

  void _showLogoutDialog(BuildContext context) {
    if (!_isMounted.value) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)?.logout ?? "Logout",
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
                AppLocalizations.of(context)?.cancel ?? "Cancel",
                style: FontStyles.getStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                if (_isMounted.value) {
                  Navigator.of(context).pop();
                }
              },
            ),
            TextButton(
              child: Text(
                AppLocalizations.of(context)?.logout ?? "Logout",
                style: FontStyles.getStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () async {
                if (!_isMounted.value) return;
                final fbToken = await FirebaseNotifications().getToken();
                await _homeCubit.logoutUser({'app_device_token': fbToken});
              },
            ),
          ],
        );
      },
    );
  }

  void _showNotificationSheet() {
    if (!_isMounted.value) return;
    NavigationService.navigateTo('/notificationPage');
  }

  @override
  void dispose() {
    _isMounted.value = false;
    networkStatus.removeListener(_networkListener);
    _isMounted.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) async {
        if (!_isMounted.value) return;

        if (state is HomeBannerSuccess) {
          bannerData = state.bannerData;
        } else if (state is MainCategorySuccess) {
          mainCategories = state.categoryData;
        } else if (state is OffersSuccess) {
          offers = state.offerData;
        } else if (state is ShopsSuccess) {
          shops = state.shopsData;
        } else if (state is RecommendedProductSuccess) {
          recommendedProduct = state.recommendedProducts;
        } else if (state is PopularProductSuccess) {
          popularProduct = state.popularProducts;
        } else if (state is ProfileSuccess) {
          if (state.userDetail != null) {
            await _homeCubit.saveUserDetail(state.userDetail!);
            if (mounted) {
              setState(() {
                userDetail = state.userDetail;
              });
            }
          }
        } else if (state is ProfileFailed) {
          debugPrint("Profile load err: ${state.error}");
        } else if (state is TestimonialsSuccess) {
          _testimonials = state.testimonials;
        } else if (state is AdvertismentSuccess) {
          _advertismentData = state.advertismentData;
          if (_advertismentData.isNotEmpty) {
            loadAd(_advertismentData.first.script);
          }
        } else if (state is LogoutSuccess) {
          if (mounted) {
            Navigator.of(context).pop();
            await SharedPreferencesHelper.remove('token');
            await SharedPreferencesHelper.remove('user_detail');
            await AuthService().signOut();
            NavigationService.navigateAndClearStack('/onBoard');
          }
        } else if (state is LogoutFailed) {
          if (mounted) {
            showToast(state.error.toString());
          }
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
                child: ElevatedButton(
                  onPressed: () {
                    if (_isMounted.value) {
                      NavigationService.navigateTo('/loginPage', arguments: true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: Text(
                    AppLocalizations.of(context)?.login ??  'Login',
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
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (_isMounted.value) {
                              _scaffoldKey.currentState?.closeEndDrawer();
                            }
                          },
                          child: Image.asset(
                            back,
                            width: 36,
                            height: 36,
                          ),
                        ),
                        const SizedBox(height: 30),
                        if (isUserLoggedIn())
                          InkWell(
                            onTap: () {
                              if (_isMounted.value) {
                                Navigator.pop(context);
                                NavigationService.navigateTo('/profilePage');
                              }
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
                                const SizedBox(width: 10),
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
                                const Icon(Icons.arrow_forward_ios_rounded)
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
                    trailing: const Icon(
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
                      if (_isMounted.value) {
                        Navigator.pop(context);
                        NavigationService.navigateTo('/profileDetail');
                      }
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Image.asset(
                      location,
                      width: 22,
                      height: 22,
                    ),
                    trailing: const Icon(
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
                      if (_isMounted.value) {
                        Navigator.pop(context);
                        NavigationService.navigateTo('/deliveryAddress');
                      }
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Image.asset(
                      box,
                      width: 22,
                      height: 22,
                    ),
                    trailing: const Icon(
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
                      if (_isMounted.value) {
                        Navigator.pop(context);
                        NavigationService.navigateTo('/orderList', arguments: false);
                      }
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    trailing: const Icon(
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
                    onTap: () {
                      if (_isMounted.value) {
                        _showLogoutDialog(context);
                      }
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
                  const SizedBox(height: 20),
                  HeaderWidget(
                    scaffoldKey: _scaffoldKey,
                    userDetail: userDetail,
                    onTapNotificationIcon: () {
                      if (_isMounted.value) {
                        if (isUserLoggedIn()) {

                      _showNotificationSheet();
                      } else {
                      showLoginAlert(context);
                      }
                    }
                    },
                  ),
                  const SizedBox(height: 20),
                  if (bannerData.isNotEmpty)
                    SizedBox(
                      height: 160,
                      child: BannerWidget(
                        banners: bannerData,
                        paddingHorizontal: 8,
                      ),
                    )
                  else
                    const Center(child: CircularProgressIndicator()),
                  const SizedBox(height: 20),
                  if (mainCategories.isNotEmpty)
                    SizedBox(
                      height: 130,
                      child: CategoryWidget(
                        categories: mainCategories,
                      ),
                    ),
                  const SizedBox(height: 20),
                  if (recommendedProduct.isNotEmpty)
                    RecommendedWidget(
                      products: recommendedProduct,
                      onTapLikeIcon: (ProductData product) {
                        if (!_isMounted.value) return;
                        final param = {"product_id": product.id};
                        setState(() {
                          product.isInWishlist = true;
                        });
                        context.read<CommonCubit>().addProductToWishList(param);
                      },
                      onTapCartIcon: (ProductData product) {
                        if (!_isMounted.value) return;
                        final param = {"product_variant_id": product.product_variant_id ?? ''};
                        context.read<CommonCubit>().addProductToCart(param);
                      },
                    ),
                  if (recommendedProduct.isNotEmpty)
                    const SizedBox(height: 20),
                  if (offers.isNotEmpty)
                    const ExcitingOffersWidget(),
                  const SizedBox(height: 20),
                  if (shops.isNotEmpty)
                    ShopsWidget(
                      shops: shops,
                    ),
                  const SizedBox(height: 20),
                  if (_advertismentData.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 147,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: WebViewWidget(
                        controller: _controller,
                      ),
                    ),
                  if (_advertismentData.isNotEmpty)
                    const SizedBox(height: 20),
                  if (popularProduct.isNotEmpty)
                    PopularItemWidget(
                      products: popularProduct,
                      onTapLikeIcon: (ProductData product) {
                        if (!_isMounted.value) return;
                        final param = {"product_id": product.id};
                        setState(() {
                          product.isInWishlist = true;
                        });
                        context.read<CommonCubit>().addProductToWishList(param);
                      },
                      onTapCartIcon: (ProductData product) {
                        if (!_isMounted.value) return;
                        final param = {"product_variant_id": product.product_variant_id ?? ''};
                        context.read<CommonCubit>().addProductToCart(param);
                      },
                    ),
                  if (popularProduct.isNotEmpty)
                    const SizedBox(height: 20),
                  if (_testimonials.isNotEmpty)
                    const CustomerReviewWidget(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}