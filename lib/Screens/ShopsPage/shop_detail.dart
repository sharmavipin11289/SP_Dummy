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
import '../../CommonFiles/cubit/common_cubit.dart';
import '../../CommonFiles/image_file.dart';
import '../../CommonFiles/text_style.dart';
import '../../CommonWidgets/bottom_sheet.dart';
import '../../CommonWidgets/category_widget.dart';
import '../../CommonWidgets/product_card.dart';
import '../HomePage/Model/shop_model.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = BlocProvider.of<ShopsCubit>(context);
    shopData = widget.args['data'] as ShopData;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // This function will be called after the widget build is complete
      _getDetails(shopData.id ?? '');
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
          child: SingleChildScrollView(
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
                      categoryData: shopDetail?.preferredCategories ?? [],
                    ),
                  ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    AppLocalizations.of(context)?.products ?? 'Products',
                    style: FontStyles.getStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
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
                if (_products.isEmpty && (!_showLoader)) Center(child: Text('Empty')),
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
        }
      }),
    );
  }
}
