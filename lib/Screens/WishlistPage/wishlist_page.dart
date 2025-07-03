import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanaa/CommonFiles/Model/products_model.dart';
import 'package:sanaa/CommonFiles/common_function.dart';
import 'package:sanaa/CommonWidgets/product_card.dart';
import 'package:sanaa/Screens/WishlistPage/cubit/wish_list_cubit.dart';
import 'package:sanaa/Screens/WishlistPage/cubit/wish_list_state.dart';
import '../../CommonFiles/cubit/common_cubit.dart';
import '../../CommonFiles/image_file.dart';
import '../../CommonFiles/text_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WishListPage extends StatefulWidget {
  const WishListPage({super.key});

  @override
  State<WishListPage> createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  late WishListCubit _wishListCubit;
  List<ProductData> _products = [];
  bool _showLoader = false;
  bool _showDeleteLoader = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _wishListCubit = BlocProvider.of<WishListCubit>(context);
    _getWishListProducts();
    /*_wishListCubit.addProductToWishList({
      "product_id": "9df30644-0b11-4216-844c-bfa0840bba30"
    });*/
  }

  _getWishListProducts() async {
    await _wishListCubit.getWishListProduct();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WishListCubit, WishListState>(
      listener: (context, state) {
        _showLoader = false;
        _showDeleteLoader =  false;
        if (state is WishListLoading) {
          _showLoader = true;
        } else if (state is WishListFailed) {
          showToast(state.error);
        } else if (state is WishListSuccess) {
            _products = state.products;
        } else if(state is DeleteWishListLoading) {
          _showDeleteLoader =  true;
        } else if(state is DeleteWishListFailed) {
          showToast(state.error);
        }else if(state is DeleteWishListSuccess) {
          _wishListCubit.getWishListProduct();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: SizedBox(),
            /*Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(back),
            ),*/
            title: Text(
              AppLocalizations.of(context)?.wishlist ?? 'Wishlist',
              style: FontStyles.getStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Two columns
                              crossAxisSpacing: 20, // Horizontal spacing
                              mainAxisSpacing: 20, // Vertical spacing
                              childAspectRatio: 0.85),
                          itemCount: _products.length, // Number of items in the grid
                          itemBuilder: (context, index) {
                            return ProductCard(
                              product: _products[index],
                              onTapLikeIcon: (ProductData product ){
                                final param = {
                                  "product_id":product.id
                                };
                                _wishListCubit.deleteProductFromWishList(param);
                              },
                              onTapCartIcon: (ProductData product) {
                                final param = {"product_variant_id": product.product_variant_id ?? ''};
                                context.read<CommonCubit>().addProductToCart(param);
                              },
                            );
                          },
                        ),
                      ),
                      if (_showLoader)
                        Center(
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                ),
                if(_products.length < 1)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        AppLocalizations.of(context)?.noProductFoundInYourWishList ?? 'No product found in your wishlist!!',
                        textAlign: TextAlign.center,
                        style: FontStyles.getStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade400
                        ),
                      ),
                    ),
                  ),
                if((_products.length < 1  &&  (_showLoader)) || _showDeleteLoader)
                  Center(child: CircularProgressIndicator(),),
              ],
            ),
          ),
        );
      },
    );
  }
}
