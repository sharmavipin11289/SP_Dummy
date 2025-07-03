import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanaa/CommonFiles/Model/products_model.dart';
import 'package:sanaa/CommonFiles/common_variables.dart';
import 'package:sanaa/CommonWidgets/drop_down_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sanaa/Navigation/navigation_service.dart';
import 'package:sanaa/Screens/ShopsPage/cubit/shops_cubit.dart';
import 'package:sanaa/Screens/ShopsPage/cubit/shops_state.dart';
import 'package:sanaa/Screens/ShopsPage/model/shop_detail_model.dart';
import '../../CommonFiles/common_function.dart';
import '../../CommonFiles/cubit/common_cubit.dart';
import '../../CommonFiles/image_file.dart';
import '../../CommonFiles/text_style.dart';
import '../../CommonWidgets/bottom_sheet.dart';
import '../../CommonWidgets/category_widget.dart';
import '../../CommonWidgets/product_card.dart';
import '../HomePage/Model/shop_model.dart';
import '../ProductDetailPage/model/product_review_model.dart';
import '../WishlistPage/cubit/wish_list_cubit.dart';

class ShopDetailPage extends StatefulWidget {
  Map<String, dynamic> args;

  ShopDetailPage(this.args, {super.key});

  @override
  State<ShopDetailPage> createState() => _ShopDetailPageState();
}

class _ShopDetailPageState extends State<ShopDetailPage> {
  late ShopData shopData;
  ShopDetail? shopDetail;
  late ShopsCubit _cubit;
  List<ProductData> _products = [];
  int? _selectedSortIndex;
  String _selectedCategory = '';
  String _sortValue = '';
  bool _showLoader = false;
  int currentTab = 0;
  List<ProductReview> _productReviews = [];
  bool _showReview = false;
  TextEditingController _reviewController = TextEditingController();
  double _rating = 5;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = BlocProvider.of<ShopsCubit>(context);
    shopData = widget.args['data'] as ShopData;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // This function will be called after the widget build is complete
      _getDetails(shopData.id ?? '');
      _getShopReviews();
    });
  }

  _getDetails(String shopID) async {
    setState(() {
      _showLoader = true;
    });
    await _cubit.getShopDetail(shopID);
  }

  _getProducts() async {
    String param = '${shopDetail?.id ?? ''}';
    if(_selectedCategory.isNotEmpty){
      param = '$param&category=$_selectedCategory';
    }
    if(_sortValue.isNotEmpty) {
      param = '$param&sort=$_sortValue';
    }
    await _cubit.getShopProducts(param);
  }

  _getShopReviews() async{
    await _cubit.getShopReviews(shopData.id ?? '');
  }

  void _showCategories(BuildContext context) {
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
                AppLocalizations.of(context)?.category ?? 'Category',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              for (var i = 0; i < (shopDetail?.preferredCategories?.length ?? 0); i++)
                RadioListTile<String>(
                  title: Text(shopDetail?.preferredCategories?[i].name ?? ''),
                  value: shopDetail?.preferredCategories?[i].name ?? '',
                  groupValue: _selectedCategory,
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                    _getProducts();
                    Navigator.pop(context); // Close BottomSheet
                  },
                ),
            ],
          ),
        );
      },
    );
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
          AppLocalizations.of(context)?.shopDetail ?? 'Shop Detail',
          style: FontStyles.getStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocConsumer<ShopsCubit, ShopsState>(builder: (context, state) {
        return SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(35),
                            child: Image.network(
                              shopDetail?.businessLogoUrl ?? dummyImageUrl,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            shopDetail?.businessName ?? '',
                            style: FontStyles.getStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        shopDetail?.description ?? '',
                        style: FontStyles.getStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if (shopDetail?.preferredCategories != null)
                      SizedBox(
                        height: 130,
                        child: CategoryWidget(
                          categories: shopDetail?.preferredCategories ?? [],
                        ),
                      ),
                    SizedBox(
                      height: 20,
                    ),
                    SelectableTabs(onTabChange: (index){
                      setState(() {
                        currentTab = index;
                      });
                    },),
                    SizedBox(
                      height: 20,
                    ),
                    if(currentTab == 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${_productReviews.length} ${AppLocalizations.of(context)?.reviews ?? 'Reviews'}',
                                  style: FontStyles.getStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    if(isUserLoggedIn()) {
                                      setState(() {
                                        _showReview = true;
                                      });
                                    }else{
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
                    if(currentTab == 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                              onTap: () {
                                _showCategories(context);
                              },
                              child: DropDownContainer(option: AppLocalizations.of(context)?.category ?? 'Category')),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                ),
                                builder: (context) => SortBottomSheet(
                                  onOptionSelected: (index) {
                                    setState(() {
                                      _selectedSortIndex = index;
                                    });
                                  },
                                  selectedOption: _selectedSortIndex, selectedValue: (value ) {
                                    _sortValue = value;
                                    _getProducts();
                                },
                                ),
                              );
                            },
                            child: DropDownContainer(
                              option: AppLocalizations.of(context)?.sortBy ?? 'Sort By',
                              borderColor: Colors.transparent,
                              backgroundColor: Color(0xFFEFEDE7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if(currentTab == 0)
                    if (_products.isEmpty && (!_showLoader)) Center(child: Text(AppLocalizations.of(context)?.empty ?? 'Empty')),
                    if(currentTab == 0)
                    if (_products.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Two columns
                              crossAxisSpacing: 20, // Horizontal spacing
                              mainAxisSpacing: 20, // Vertical spacing
                              childAspectRatio: 0.85),
                          itemCount: _products.length,
                          // Number of items in the grid
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
                                }else{
                                  print(">>>>>");
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
                  ],
                ),
              ),
              if (_showReview)
                buildReviewDialog(context: context, title: AppLocalizations.of(context)?.writeAReview ?? 'Write a Review',rateText: AppLocalizations.of(context)?.rate ?? 'Rate',hintText: AppLocalizations.of(context)?.describeYourExperience ?? 'Describe your experience?',submitText: AppLocalizations.of(context)?.submitReview ?? 'Submit Review', emptyReviewMessage: AppLocalizations.of(context)?.reviewDetailShouldNotBeEmpty ?? "Review should not be empty", reviewController: _reviewController, rating: _rating, onRatingChanged: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                }, onSubmit: (param){
                  _cubit.submitProductReview(param, shopData.id ?? '');
                }, productId: '', crossTapped: (){setState(() {
                  _showReview = false;
                });}),
            ],
          ),
        );
      }, listener: (context, state) {
        if (state is ShopProductSuccess) {
          _products = state.products;
          _showLoader = false;
        } else if (state is ShopDetailSuccess) {
          if (state.shopData != null) {
            shopDetail = state.shopData!;
            _showLoader = true;
            _getProducts();
          }
        } else if (state is ShopReviewSuccess) {
           _productReviews =  state.reviews;
        } else if(state is SubmitReviewSuccess) {
          setState(() {
            _showReview = false;
            _getShopReviews();
          });
        }
      }),
    );
  }
}




class SelectableTabs extends StatefulWidget {
  Function(int) onTabChange;
   SelectableTabs({Key? key, required this.onTabChange}) : super(key: key);

  @override
  _SelectableTabsState createState() => _SelectableTabsState();
}

class _SelectableTabsState extends State<SelectableTabs> {
  int _selectedIndex = 0; // Default to "REVIEW" tab (index 1)

  void _onTabTap(int index) {
    setState(() {
      if (_selectedIndex != index) {
        _selectedIndex = index;
        widget.onTabChange(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _onTabTap(0),
              child: Container(
                decoration: BoxDecoration(
                  color: _selectedIndex == 0 ? Colors.green : Colors.grey[200],
                  border: _selectedIndex == 0
                      ? Border(bottom: BorderSide(color: Colors.red, width: 2))
                      : null,
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)?.product ?? "PRODUCT",
                    style: TextStyle(
                      color: _selectedIndex == 0 ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _onTabTap(1),
              child: Container(
                decoration: BoxDecoration(
                  color: _selectedIndex == 1 ? Colors.green : Colors.grey[200],
                  border: _selectedIndex == 1
                      ? Border(bottom: BorderSide(color: Colors.red, width: 2))
                      : null,
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)?.reviews ?? "REVIEW",
                    style: TextStyle(
                      color: _selectedIndex == 1 ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
