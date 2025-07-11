import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanaa/CommonFiles/Model/products_model.dart';
import 'package:sanaa/CommonWidgets/banner_widget.dart';
import 'package:sanaa/CommonWidgets/product_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sanaa/CommonWidgets/recommended_widget.dart';
import 'package:sanaa/Screens/ExcitingOfferPage/cubit/product_cubit.dart';
import 'package:sanaa/Screens/ExcitingOfferPage/cubit/product_state.dart';
import 'package:sanaa/Screens/HomePage/Model/advertisment_model.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../CommonFiles/cubit/common_cubit.dart';
import '../../CommonFiles/image_file.dart';
import '../../CommonFiles/text_style.dart';
import '../../CommonWidgets/bottom_sheet.dart';
import '../../Navigation/navigation_service.dart';
import '../WishlistPage/cubit/wish_list_cubit.dart';

class ExcitingOfferPage extends StatefulWidget {
  String title;
  String? category;
  String? vendorId;
  String? excitingOfferId;
  String? view;

  ExcitingOfferPage({super.key, required this.title, this.category, this.excitingOfferId, this.vendorId, this.view});

  @override
  State<ExcitingOfferPage> createState() => _ExcitingOfferPageState();
}

class _ExcitingOfferPageState extends State<ExcitingOfferPage> {
  int _selectedOption = 0;
  List<ProductData> _products = [];
  int page = 1;
  String search = "";
  int? minPrice;
  int? maxPrice;
  List<String> categoryIds = [];
  String limit = "10"; // Default limit for pagination
  String? productId;
  bool _showLoader = false;
  bool _hasMore = true; // Track if more data is available
  Map<String, dynamic>? filterParam;
  String sortValue = '';
  List<AdvertismentData> _advertismentData = [];
  late WebViewController _controller;
  late ProductCubit _cubit;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    print("::::::::::::::: ${widget.category}");
    _cubit = BlocProvider.of<ProductCubit>(context);
    _showLoader = true;
    _getProducts();
    _getAdvertisment();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              print('WebView loading: $progress%');
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) {},
            onWebResourceError: (WebResourceError error) {
              print('WebView error: $error');
            },
          ),
        );
      _scrollController.addListener(_onScroll);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !_showLoader &&
        _hasMore) {
      page++;
      _getProducts();
    }
  }

  void loadAd(String jsonData) {
    final String adScript = jsonData;
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
      $adScript
    </body>
    </html>
    ''';
    _controller.loadHtmlString(htmlContent);
  }

  _getAdvertisment() async {
    await _cubit.getAdvertismentData();
  }

  Future<void> _getProducts() async {
    final baseParams = _buildParam();
    Map<String, dynamic> requestParams = Map.from(baseParams);

    if (filterParam != null) {
      requestParams.addAll(filterParam!);
    }

    if (sortValue.isNotEmpty) {
      requestParams['sort'] = sortValue;
    }

    await _cubit.getProducts(requestParams);
  }

  Map<String, dynamic> _buildParam() {
    Map<String, dynamic> params = {
      "page": page,
      "limit": limit,
      if (search.isNotEmpty) "search": search,
      if (minPrice != null) "min_price": minPrice,
      if (maxPrice != null) "max_price": maxPrice,
      if (widget.view != null && (widget.view?.isNotEmpty ?? false)) "view": widget.view,
      if (productId != null) "product_id": productId,
      if (widget.category != null && (widget.category?.isNotEmpty ?? false)) "category": widget.category,
      if (widget.vendorId != null && (widget.vendorId?.isNotEmpty ?? false)) "vendor_id": widget.vendorId,
      if (widget.excitingOfferId != null && (widget.excitingOfferId?.isNotEmpty ?? false)) "exciting_offer_id": widget.excitingOfferId,
    };

    for (int i = 0; i < categoryIds.length; i++) {
      params["category_ids[$i]"] = categoryIds[i];
    }

    return params;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            NavigationService.goBack();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(back),
          ),
        ),
        title: Text(
          widget.title,
          style: FontStyles.getStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: BlocConsumer<ProductCubit, ProductsState>(
            builder: (context, state) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                              ),
                              builder: (context) => SortBottomSheet(
                                selectedOption: _selectedOption,
                                onOptionSelected: (selected) {
                                  setState(() {
                                    _selectedOption = selected;
                                  });
                                },
                                selectedValue: (value) {
                                  setState(() {
                                    sortValue = value;
                                    page = 1; // Reset to first page on sort
                                    _products.clear();
                                    _hasMore = true;
                                  });
                                  _getProducts();
                                },
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 1,
                                color: Color(0xFFC1DAC1),
                              ),
                            ),
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(sort, width: 20),
                                SizedBox(width: 8),
                                Text(
                                  AppLocalizations.of(context)?.sort ?? 'Sort',
                                  style: FontStyles.getStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            await NavigationService.navigateTo('/filterPage',
                                arguments: (((widget.category == null)
                                    ? false
                                    : (widget.category!.isEmpty)
                                    ? false
                                    : true)))
                                .then((value) {
                              final param = value as Map<String, dynamic>;
                              setState(() {
                                filterParam = param;
                                page = 1; // Reset to first page on filter
                                _products.clear();
                                _hasMore = true;
                              });
                              _getProducts();
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 1,
                                color: Color(0xFFC1DAC1),
                              ),
                            ),
                            height: 40,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(filter, width: 20),
                                const SizedBox(width: 8),
                                Text(
                                  AppLocalizations.of(context)?.filter ?? 'Filter',
                                  style: FontStyles.getStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  /* BannerWidget(
                    paddingHorizontal: 0,
                  ),*/
                  SizedBox(height: 20),
                  if (_products.isEmpty && !_showLoader)
                    Expanded(
                      child: Center(
                        child: Text(AppLocalizations.of(context)?.dataNotAvailable ?? 'Data Not Available'),
                      ),
                    ),
                  if (_products.isNotEmpty)
                    Expanded(
                      child: GridView.builder(
                        controller: _scrollController,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 1 / 1.17,
                        ),
                        itemCount: _products.length,
                        itemBuilder: (context, index) {
                          return ProductCard(
                            product: _products[index],
                            onTapLikeIcon: (ProductData product) {
                              if (product.isInWishlist ?? false) {
                                setState(() {
                                  product.isInWishlist = false;
                                });
                                final param = {"product_id": product.id};
                                context.read<WishListCubit>().deleteProductFromWishList(param);
                              } else {
                                final param = {"product_id": product.id};
                                setState(() {
                                  product.isInWishlist = true;
                                });
                                context.read<CommonCubit>().addProductToWishList(param);
                              }
                            },
                            onTapCartIcon: (ProductData product) {
                              final param = {"product_variant_id": product.product_variant_id ?? ''};
                              context.read<CommonCubit>().addProductToCart(param);
                            },
                          );
                        },
                      ),
                    ),
                  if (_advertismentData.isNotEmpty)
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 147,
                      child: WebViewWidget(
                        controller: _controller,
                      ),
                    ),
                  if (_showLoader)
                    const Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              );
            },
            listener: (context, state) {
              _showLoader = false;
              if (state is ProductsLoading) {
                _showLoader = true;
              } else if (state is ProductsFailed) {
                print(state.error);
              } else if (state is ProductsSuccess) {
                setState(() {
                  if (page == 1) {
                    _products = state.products;
                  } else {
                    _products.addAll(state.products);
                  }
                  // Check if there are more pages to load
                  _hasMore = state.meta?.total != null &&
                      _products.length < state.meta!.total!;
                });
              } else if (state is AdvertismentSuccess) {
                _advertismentData = state.advertismentData;
                if (_advertismentData.isNotEmpty) {
                  loadAd(_advertismentData.first.script ?? '');
                }
              }
            },
          ),
        ),
      ),
    );
  }
}

/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanaa/CommonFiles/Model/products_model.dart';
import 'package:sanaa/CommonWidgets/banner_widget.dart';
import 'package:sanaa/CommonWidgets/product_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sanaa/CommonWidgets/recommended_widget.dart';
import 'package:sanaa/Screens/ExcitingOfferPage/cubit/product_cubit.dart';
import 'package:sanaa/Screens/ExcitingOfferPage/cubit/product_state.dart';
import 'package:sanaa/Screens/HomePage/Model/advertisment_model.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../CommonFiles/cubit/common_cubit.dart';
import '../../CommonFiles/image_file.dart';
import '../../CommonFiles/text_style.dart';
import '../../CommonWidgets/bottom_sheet.dart';
import '../../Navigation/navigation_service.dart';
import '../WishlistPage/cubit/wish_list_cubit.dart';

class ExcitingOfferPage extends StatefulWidget {
  String title;
  String? category;
  String? vendorId;
  String? excitingOfferId;
  String? view;

  ExcitingOfferPage({super.key, required this.title, this.category, this.excitingOfferId, this.vendorId, this.view});

  @override
  State<ExcitingOfferPage> createState() => _ExcitingOfferPageState();
}

class _ExcitingOfferPageState extends State<ExcitingOfferPage> {
  int _selectedOption = 0;
  List<ProductData> _products = [];

  int page = 1;
  String search = "";
  int? minPrice;
  int? maxPrice;
  List<String> categoryIds = [];

  String limit = "";
  String? productId;
  bool _showLoader = false;
  Map<String, dynamic>? filterParam;
  String sortValue = '';
  List<AdvertismentData> _advertismentData = [];
  late WebViewController _controller;
  late ProductCubit _cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("::::::::::::::: ${widget.category}");
    _cubit = BlocProvider.of<ProductCubit>(context);
    _showLoader = true;
    _getProducts();
    _getAdvertisment();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted) // Enable JavaScript
        ..setBackgroundColor(const Color(0x00000000)) // Transparent background
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Optional: Update UI with loading progress
              print('WebView loading: $progress%');
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) {},
            onWebResourceError: (WebResourceError error) {
              print('WebView error: $error');
            },
          ),
        );
    });
  }

  void loadAd(String jsonData) {
    final String adScript = jsonData;

    // Create a full HTML document to wrap the ad script
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
      $adScript
    </body>
    </html>
    ''';

    // Load the HTML content into the WebView
    _controller.loadHtmlString(htmlContent);
  }

  _getAdvertisment() async {
    await _cubit.getAdvertismentData();
  }

  Future<void> _getProducts() async {
    final baseParams = _buildParam();
    Map<String, dynamic> requestParams = Map.from(baseParams);

    if (filterParam != null) {
      requestParams.addAll(filterParam!);
    }

    if (sortValue.isNotEmpty) {
      requestParams['sort'] = sortValue;
    }

    await _cubit.getProducts(requestParams);
  }

  Map<String, dynamic> _buildParam() {
    // Creating a map of parameters
    Map<String, dynamic> params = {
      "page": page,
      if (search.isNotEmpty) "search": search,
      if (minPrice != null) "min_price": minPrice,
      if (maxPrice != null) "max_price": maxPrice,
      if (widget.view != null && (widget.view?.isNotEmpty ?? false)) "view": widget.view,
      if (limit.isNotEmpty) "limit": limit,
      if (productId != null) "product_id": productId,
      if (widget.category != null && (widget.category?.isNotEmpty ?? false)) "category": widget.category,
      if (widget.vendorId != null && (widget.vendorId?.isNotEmpty ?? false)) "vendor_id": widget.vendorId,
      if (widget.excitingOfferId != null && (widget.excitingOfferId?.isNotEmpty ?? false)) "exciting_offer_id": widget.excitingOfferId,
    };

    // Adding category_ids dynamically
    for (int i = 0; i < categoryIds.length; i++) {
      params["category_ids[$i]"] = categoryIds[i];
    }

    return params;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            NavigationService.goBack();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(back),
          ),
        ),
        title: Text(
          widget.title,
          style: FontStyles.getStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: BlocConsumer<ProductCubit, ProductsState>(
            builder: (context, state) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                              ),
                              builder: (context) => SortBottomSheet(
                                selectedOption: _selectedOption,
                                onOptionSelected: (selected) {
                                  setState(() {
                                    _selectedOption = selected;
                                  });
                                },
                                selectedValue: (value) {
                                  setState(() {
                                    sortValue = value;
                                  });
                                  _getProducts();
                                },
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 1,
                                color: Color(0xFFC1DAC1),
                              ),
                            ),
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(sort, width: 20),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  AppLocalizations.of(context)?.sort ?? 'Sort',
                                  style: FontStyles.getStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            await NavigationService.navigateTo('/filterPage',
                                    arguments: (((widget.category == null)
                                        ? false
                                        : (widget.category!.isEmpty)
                                            ? false
                                            : true)))
                                .then((value) {
                              final param = value as Map<String, dynamic>;
                              filterParam = param;
                              _getProducts();
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 1,
                                color: Color(0xFFC1DAC1),
                              ),
                            ),
                            height: 40,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(filter, width: 20),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  AppLocalizations.of(context)?.filter ?? 'Filter',
                                  style: FontStyles.getStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  */
/* BannerWidget(
                paddingHorizontal: 0,
              ),*//*

                  SizedBox(
                    height: 20,
                  ),
                  if (_products.isEmpty && !_showLoader)
                    Expanded(
                      child: Center(
                        child: Text(AppLocalizations.of(context)?.dataNotAvailable ?? 'Data Not Available'),
                      ),
                    ),
                  if (_products.isNotEmpty)
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Two columns
                          crossAxisSpacing: 20, // Horizontal spacing
                          mainAxisSpacing: 20,
                          childAspectRatio: 1 / 1.17,
                        ),
                        itemCount: _products.length, // Number of items in the grid
                        itemBuilder: (context, index) {
                          return ProductCard(
                            product: _products[index],
                            onTapLikeIcon: (ProductData product) {
                              if (product.isInWishlist ?? false) {
                                setState(() {
                                  product.isInWishlist = false;
                                });
                                final param = {"product_id": product.id};
                                context.read<WishListCubit>().deleteProductFromWishList(param);
                              } else {
                                final param = {"product_id": product.id};
                                setState(() {
                                  product.isInWishlist = true;
                                });
                                context.read<CommonCubit>().addProductToWishList(param);
                              }
                            },
                            onTapCartIcon: (ProductData product) {
                              final param = {"product_variant_id": product.product_variant_id ?? ''};
                              context.read<CommonCubit>().addProductToCart(param);
                            },
                          );
                        },
                      ),
                    ),
                  if (_advertismentData.length > 0)
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 147,
                      child: WebViewWidget(
                        controller: _controller,
                      ),
                    ),
                  if (_showLoader)
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              );
            },
            listener: (context, state) {
              _showLoader = false;
              if (state is ProductsLoading) {
                _showLoader = true;
              } else if (state is ProductsFailed) {
                print(state.error);
              } else if (state is ProductsSuccess) {
                _products = state.products;
              } else if (state is AdvertismentSuccess) {
                _advertismentData = state.advertismentData;
                loadAd(_advertismentData.first.script ?? '');
              }
            },
          ),
        ),
      ),
    );
  }
}
*/
