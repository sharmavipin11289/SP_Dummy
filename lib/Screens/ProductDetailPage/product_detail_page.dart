import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:sanaa/CommonFiles/Model/products_model.dart';
import 'package:sanaa/CommonFiles/common_function.dart';
import 'package:sanaa/CommonFiles/common_variables.dart';
import 'package:sanaa/CommonFiles/image_file.dart';
import 'package:sanaa/CommonWidgets/product_card.dart';
import 'package:sanaa/Screens/ProductDetailPage/cubit/product_detail_cubit.dart';
import 'package:sanaa/Screens/ProductDetailPage/cubit/product_detail_state.dart';
import 'package:sanaa/Screens/ProductDetailPage/model/product_detail_model.dart';
import 'package:sanaa/Screens/ProductDetailPage/model/product_review_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../CommonFiles/cubit/common_cubit.dart';
import '../../CommonFiles/text_style.dart';
import '../../Navigation/navigation_service.dart';
import '../../SharedPrefrence/shared_prefrence.dart';
import '../Tabbar/tabbar_notifier.dart';

class ProductDetailPage extends StatefulWidget {
  String productID;

  ProductDetailPage({required this.productID});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final PageController _pageController = PageController();
  ProductDetail? _productDetail;
  late ProductDetailCubit _cubit;
  bool _showLoader = false;
  SizeVariants? _selectedSize;
  List<SizeVariants> _sizes = [];
  ColorVariants? _selectedColor;
  List<ColorVariants> _colors = [];
  List<ProductData> _relatedProducts = [];
  List<ProductReview> _productReviews = [];
  TextEditingController _reviewController = TextEditingController();
  double _rating = 5;
  bool _showReview = false;
  String size_id = '';
  late Timer _timer;
  int _currentPage = 0;

  List<String> productIds = [];
  int _reviewPage = 1;
  int _reviewCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productIds.add(widget.productID);
    _cubit = BlocProvider.of<ProductDetailCubit>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Ensure widget is still mounted
        _getProductDetail({});
        _timer = Timer.periodic(Duration(seconds: 3), _autoScroll);
      }
    });
  }

  void _autoScroll(Timer timer) {
    if (!mounted || (_productDetail?.images?.length ?? 0) < 2) {
      return;
    }
    if (_currentPage < (_productDetail?.images?.length ?? 0) - 1) {
      _currentPage++;
    } else {
      _currentPage = 0;
    }

    if (_pageController.hasClients) {
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  _getProductDetail(Map<String, dynamic> param) async {
    if (productIds.length < 1) {
      await _cubit.getProductDetail(widget.productID, param);
    } else {
      await _cubit.getProductDetail(productIds.last, param);
    }
  }

  _getRelatedProducts() async {
    print(":::::::::: ${_productDetail?.id ?? ''}");
    await _cubit.getRelatedProducts({'view': 'related', 'product_id': (_productDetail?.id ?? '')});
  }

  _getReviews() async {
    await _cubit.getProductReview(_productDetail?.id ?? '', page: _reviewPage);
  }

  void _showSize(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               Text(
                AppLocalizations.of(context)?.chooseSize ?? 'Choose Size',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              for (var i = 0; i < _sizes.length; i++)
                RadioListTile<SizeVariants>(
                  title: Text(_sizes[i].name ?? ''),
                  value: _sizes[i],
                  groupValue: _selectedSize,
                  onChanged: (value) {
                    setState(() {
                      _selectedSize = value!;
                      size_id = _sizes[i].id ?? '';
                    });
                    final param = {'size_id': size_id};
                    print(param);
                    _getProductDetail(param);
                    Navigator.pop(context); // Close BottomSheet
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  _handleBackEvent() {
    productIds.removeLast();
    if (productIds.isEmpty) {
      NavigationService.goBack();
    } else {
      widget.productID = productIds.last;
      _getProductDetail({});
    }
  }

  Widget _buildPriceText() {
    final hasDiscount = (_productDetail?.discountPercentage ?? '0').isNotEmpty && double.parse(_productDetail?.discountPercentage ?? '0.0') > 0;
    final isPriceSmall = (_productDetail?.price ?? 0) < (_productDetail?.originalPrice ?? 0);
    print("hasDiscount $hasDiscount");
    print("hasSmall $isPriceSmall");
    return Text(
      '${_productDetail?.currency ?? 'KES'} ${hasDiscount && isPriceSmall ? (_productDetail?.price?.toString() ?? '0') : (hasDiscount && !(isPriceSmall)) ? (_productDetail?.originalPrice?.toString() ?? '0') : (_productDetail?.price?.toString() ?? '0')}',
      style: FontStyles.getStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF006600),
      ),
    );
  }

  Widget _buildDiscountedText() {
    final hasDiscount = (_productDetail?.discountPercentage ?? '0').isNotEmpty && double.parse(_productDetail?.discountPercentage ?? '0.0') > 0;
    final isPriceSmall = (_productDetail?.price ?? 0) < (_productDetail?.originalPrice ?? 0);

    return Text(
      '${_productDetail?.currency ?? 'KES'} ${hasDiscount && isPriceSmall ? (_productDetail?.originalPrice?.toString() ?? '0') : (hasDiscount && !(isPriceSmall)) ? (_productDetail?.price?.toString() ?? '0') : (_productDetail?.originalPrice?.toString() ?? '0')}',
      style: FontStyles.getStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xFF77878F), decoration: TextDecoration.lineThrough),
    );
  }

  _getSummary() async {
    if (_productDetail?.isInCart == true) {
      _doSummaryProcess();
    } else {
      final param = {"product_variant_id": _productDetail?.product_variant_id ?? ''};
      context.read<CommonCubit>().addProductToCart(param);
      setState(() {
        _productDetail?.isInCart = true;
      });
      _doSummaryProcess();
    }
  }

  _doSummaryProcess() async {
    await context.read<CommonCubit>().checkoutInitiate();
    final param = {
      "currency": SharedPreferencesHelper.getString('savedCurrency') ?? 'KES',
    };

    _cubit.getOrderSummary(param);

    /*Future.delayed(Duration(seconds: 1), (){
      context.read<TabControllerProvider>().changeTabIndex(2);
      Navigator.pop(context);
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          print("Pop occurred");
        } else {
          // Handle Android back button or iOS swipe when canPop is false
          _handleBackEvent();
        }
      },
      child: Scaffold(
        body: BlocConsumer<ProductDetailCubit, ProductDetailState>(builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    Container(
                      height: 300,
                      child: Stack(children: [
                        PageView(
                          controller: _pageController,
                          children: [
                            for (var i = 0; i < (_productDetail?.images?.length ?? 0); i++)
                              Image.network(
                                _productDetail?.images?[i] ?? dummyImageUrl,
                                height: 311,
                                fit: BoxFit.fitWidth,
                              ),
                          ],
                        ),
                        SafeArea(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              NavigationService.goBack();
                            },
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: Image.asset(back),
                            ),
                          ),
                        )),
                      ]),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    if (_productDetail != null) Center(child: SmoothPageIndicator(controller: _pageController, count: (_productDetail?.images?.length ?? 0))),
                    // Product Information
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _productDetail?.name ?? '',
                            style: FontStyles.getStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)?.availability ?? 'Availability:',
                                style: FontStyles.getStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                (_productDetail?.isOutOfStock ?? false) ? AppLocalizations.of(context)?.outOfStock ?? 'Out Of Stock' : AppLocalizations.of(context)?.inStock ?? 'InStock',
                                style: FontStyles.getStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: (_productDetail?.isOutOfStock ?? false) ? Colors.red : Color(0xFF318531),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              _buildPriceText(),
                              SizedBox(width: 8),
                              _buildDiscountedText(),
                              SizedBox(width: 30),
                              if (double.parse(_productDetail?.discountPercentage ?? "0.0") > 0.0)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(3),
                                  child: Container(
                                    height: 20,
                                    color: Color(0xFFBC1320),
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    child: Text(
                                      '${_productDetail?.discountPercentage ?? ''}% ${AppLocalizations.of(context)?.off ?? 'OFF'}',
                                      style: FontStyles.getStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              StarRating(
                                size: 16,
                                rating: _productDetail?.averageRating ?? 0.0,
                                allowHalfRating: true,
                                onRatingChanged: (rating) {},
                                color: Color(0xFFFFCE00),
                                emptyIcon: Icons.star,
                                halfFilledIcon: Icons.star_half_outlined,
                                filledIcon: Icons.star,
                              ),
                              SizedBox(width: 8),
                              Text(
                                '${_productDetail?.averageRating ?? 0.0} ' + (AppLocalizations.of(context)?.starRating ?? 'Star Rating'),
                                style: FontStyles.getStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 6),
                              Text(
                                '(${_productDetail?.ratingCount ?? 0} ${AppLocalizations.of(context)?.userFeedback ?? 'User feedback'})',
                                style: FontStyles.getStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 8),
                          if (_sizes.length > 0)
                            // Size Selection
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)?.selectSize ?? 'Select Size:',
                                      style: FontStyles.getStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: () {
                                        _showSize(context);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(left: 12, right: 9),
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color: Color(0xFFC1DAC1),
                                            width: 1.0, // Border width
                                          ),
                                        ),
                                        height: 34,
                                        child: Row(
                                          children: [
                                            Text(
                                              _selectedSize?.name ?? '',
                                              style: FontStyles.getStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Icon(
                                              Icons.keyboard_arrow_down_sharp,
                                              size: 16,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                if (_colors.length > 0)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)?.selectColor ?? 'Select Color:',
                                        style: FontStyles.getStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          for (var i = 0; i < _colors.length; i++)
                                            GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _selectedColor = _colors[i];
                                                    final param = {'color_id': (_selectedColor?.id ?? '')};
                                                    _getProductDetail(param);
                                                  });
                                                },
                                                child: _buildColorOption(hexToColor(_colors[i].value ?? ''), ((_selectedColor?.id ?? '') == _colors[i].id))),
                                        ],
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          SizedBox(height: 20),
                          if (_productDetail?.isOutOfStock == false)
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      if (!isUserLoggedIn()) {
                                        showLoginAlert(context);
                                        return;
                                      }
                                      _getSummary();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(left: 12, right: 9),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Color(0xFFC1DAC1),
                                          width: 1.0, // Border width
                                        ),
                                      ),
                                      height: 40,
                                      child: Center(
                                        child: Text(
                                          AppLocalizations.of(context)?.buyNow ?? 'BUY NOW',
                                          style: FontStyles.getStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      if (!isUserLoggedIn()) {
                                        showLoginAlert(context);
                                        return;
                                      }
                                      if (_productDetail?.isInCart ?? false) {
                                        print("already in cart!!!");
                                      } else {
                                        final param = {"product_variant_id": _productDetail?.product_variant_id ?? ''};
                                        context.read<CommonCubit>().addProductToCart(param);
                                        setState(() {
                                          _productDetail?.isInCart = true;
                                        });
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(left: 12, right: 9),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF318531),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      height: 40,
                                      child: Center(
                                        child: FittedBox(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                (_productDetail?.isInCart ?? false) ? AppLocalizations.of(context)?.addedInCart ?? 'Added In Cart' : AppLocalizations.of(context)?.addToCart ?? 'Add To Cart',
                                                style: FontStyles.getStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFFFFFFFF)),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Image.asset(
                                                cartWhite,
                                                width: 20,
                                                height: 20,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(),

                    // Additional Sections
                    _buildExpandableSection(AppLocalizations.of(context)?.description ?? 'Descriptions', _productDetail?.description ?? '', context),

                    Divider(),

                    _buildExpandableSection(
                      AppLocalizations.of(context)?.additionalInformation ?? 'Additional Information',
                      _productDetail?.additionalInformation ?? '',
                      context,
                    ),

                    Divider(),

                    Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent, // Remove the gray line
                        expansionTileTheme: ExpansionTileThemeData(
                          backgroundColor: Colors.transparent, // No background when expanded
                          collapsedBackgroundColor: Colors.transparent, // No background when collapsed
                        ),
                      ),
                      child: ExpansionTile(
                        title: Text(
                          AppLocalizations.of(context)?.reviews ?? 'REVIEWS',
                          style: FontStyles.getStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        tilePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0), // Reduce vertical padding
                        childrenPadding: EdgeInsets.all(16), // Padding for expanded content
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10, top: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${_reviewCount} ${AppLocalizations.of(context)?.reviews ?? 'Reviews'}',
                                      style: FontStyles.getStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        if (isUserLoggedIn()) {
                                          setState(() {
                                            _showReview = true;
                                          });
                                        } else {
                                          showLoginAlert(context);
                                        }
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)?.writeAReview ?? 'Write a Review',
                                        style: FontStyles.getStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF318531),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                for (var i = 0; i < _productReviews.length; i++) buildReviewTile(_productReviews[i]),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Reviews Section
                    Divider(),

                    // Vendor Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        height: 66,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(
                              0xFFC1DAC1,
                            ),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(33),
                        ),
                        padding: const EdgeInsets.all(13.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(_productDetail?.vendorDetails?.businessLogoUrl ?? dummyImageUrl), // Vendor logo
                              radius: 20,
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _productDetail?.vendorDetails?.businessName ?? '',
                                  style: FontStyles.getStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  (_productDetail?.vendorDetails?.verified ?? false) ? AppLocalizations.of(context)?.verifyVendor ?? 'Verified Vendor' : AppLocalizations.of(context)?.unVerifiedVendor ?? 'Unverified Vendor',
                                  style: FontStyles.getStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                final shop = _productDetail?.vendorDetails;
                                NavigationService.navigateTo('/shopDetailPage', arguments: {'data': shop});
                              },
                              child: Text(
                                AppLocalizations.of(context)?.knowMore ?? 'Know More',
                                style: FontStyles.getStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFBC1320),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 32,
                    ),
                    if (_relatedProducts.length > 0)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)?.relatedProduct ?? 'Related Product',
                              style: FontStyles.getStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    if (_relatedProducts.length > 0)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (var i = 0; i < _relatedProducts.length; i++)
                                ProductCard(
                                  product: _relatedProducts[i],
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
                                  onTapProduct: (productID) {
                                    widget.productID = productID;
                                    productIds.add(productID);
                                    _getProductDetail({});
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (_showLoader)
                Center(
                  child: CircularProgressIndicator(),
                ),
              if (_showReview)
                buildReviewDialog(
                    context: context,
                    title: AppLocalizations.of(context)?.writeAReview ?? 'Write a Review',
                    rateText: AppLocalizations.of(context)?.rate ?? 'Rate',
                    hintText: AppLocalizations.of(context)?.describeYourExperience ?? 'Describe your experience?',
                    submitText: AppLocalizations.of(context)?.submitReview ?? 'Submit Review',
                    emptyReviewMessage: AppLocalizations.of(context)?.reviewDetailShouldNotBeEmpty ?? "Review should not be empty",
                    reviewController: _reviewController,
                    rating: _rating,
                    onRatingChanged: (rating) {
                      setState(() {
                        _rating = rating;
                      });
                    },
                    onSubmit: (param) {
                      _cubit.submitProductReview(param);
                    },
                    productId: _productDetail?.id ?? '',
                    crossTapped: () {
                      setState(() {
                        _reviewController.text = '';
                        _showReview = false;
                      });
                    }),
            ],
          );
        }, listener: (context, state) {
          _showLoader = false;

          if (state is ProductDetailSuccess) {
            _reviewPage = 1;
            _productDetail = state.productDetail;
            print(_productDetail?.ratingCount);
            print(_productDetail?.averageRating);
            if (_productDetail?.sizeVariants != null) {
              _sizes = _productDetail?.sizeVariants ?? [];
              if (_selectedSize == null) {
                _selectedSize = _sizes.first;
              } else {
                try {
                  final size = _productDetail?.sizeVariants?.firstWhere((e) => e.id == _selectedSize!.id);
                  _selectedSize = size;
                } catch (_) {
                  _selectedSize = _sizes.first;
                }
              }
            }
            if (_productDetail?.colorVariants != null) {
              _colors = _productDetail?.colorVariants ?? [];
              if (_selectedColor == null) {
                print(">>>>>>>>>>>>");
                // _selectedColor = _colors.first;
                print("<<<<<<<<<<<<<");
              } else {
                try {
                  final color = _productDetail?.colorVariants?.firstWhere((e) => e.id == _selectedColor!.id);
                  _selectedColor = color;
                } catch (_) {
                  _selectedColor = _colors.first;
                }
              }
            }
            _getRelatedProducts();
            _getReviews();
          } else if (state is ProductDetailFailed) {
            showToast(state.error);
          } else if (state is ProductDetailLoading) {
            _showLoader = true;
          } else if (state is RelatedProductSuccess) {
            _relatedProducts = state.relatedProducts;
          } else if (state is ProductReviewSuccess) {
            if (_reviewPage == 1) {
              _productReviews = state.productReviews;
            } else {
              _productReviews.addAll(state.productReviews);
            }

            // Check if more reviews are available
            if (state.meta != null && state.meta!.total != null && _productReviews.length < state.meta!.total!) {
              _reviewPage += 1;
              _getReviews();
            } else {
              _reviewCount = _productReviews.length;
            }
          } else if (state is SubmitReviewLoading) {
            _showLoader = true;
          } else if (state is SubmitReviewSuccess) {
            _showReview = false;
            _rating = 5;
            _reviewController.text = "";
            _reviewPage = 1;
            _getReviews();
          } else if (state is SubmitReviewFailed) {
            showToast(state.error);
          } else if (state is OrderSummeryLoading) {
            _showLoader = true;
          } else if (state is OrderSummeryLoaded) {
            if (state.summaryData != null) {
              final args = {
                'summaryData': state.summaryData,
                /*'paymentMethod': _selectedPaymentMethod?.option ?? '',*/
                'shippingMethod': 'EXPRESS_SHIPPING',
                /*'phone': (_selectedPaymentMethod?.requiresPhoneNumber?.toLowerCase() == 'yes') ? _phoneTxtCtrl.text : ''*/
              };
              print(">>>>>>>>>>");
              print(args);
              NavigationService.navigateTo("/orderSummery", arguments: args);
            }
          } else if (state is OrderSummeryFailed) {
            print(">>>>>>>>>>> FFF");
            showToast(state.error);
          }
        }),
      ),
    );
  }

  Widget _buildColorOption(Color color, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: (isSelected) ? Colors.green : Colors.grey, width: (isSelected) ? 3 : 1),
      ),
      child: CircleAvatar(
        backgroundColor: color,
        radius: 8,
      ),
    );
  }

  Widget _buildExpandableSection(String title, String content, BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent, // Remove the gray line
        expansionTileTheme: ExpansionTileThemeData(
          backgroundColor: Colors.transparent, // No background when expanded
          collapsedBackgroundColor: Colors.transparent, // No background when collapsed
        ),
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: FontStyles.getStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        tilePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0), // Reduce vertical padding
        childrenPadding: EdgeInsets.all(16), // Padding for expanded content
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10, top: 0),
            child: HtmlWidget(content),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to prevent memory leaks
    _pageController.dispose(); // Dispose of the PageController
    _reviewController.dispose(); // Dispose of the TextEditingController
    super.dispose();
  }
}
