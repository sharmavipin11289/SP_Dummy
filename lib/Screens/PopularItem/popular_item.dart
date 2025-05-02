import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanaa/CommonFiles/Model/products_model.dart';
import 'package:sanaa/CommonWidgets/product_card.dart';
import 'package:sanaa/Screens/WishlistPage/cubit/wish_list_cubit.dart';
import '../../CommonFiles/cubit/common_cubit.dart';
import '../../CommonFiles/image_file.dart';
import '../../CommonFiles/text_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PopularItem extends StatefulWidget {
  const PopularItem({super.key});

  @override
  State<PopularItem> createState() => _PopularItemState();
}

class _PopularItemState extends State<PopularItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(back),
        ),
        title: Text(
          AppLocalizations.of(context)?.recommended ?? 'Recommended',
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
          child: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Two columns
                      crossAxisSpacing: 20, // Horizontal spacing
                      mainAxisSpacing: 20, // Vertical spacing
                      childAspectRatio: 0.85),
                  itemCount: 20, // Number of items in the grid
                  itemBuilder: (context, index) {
                    return ProductCard(product: ProductData(), onTapLikeIcon: (ProductData product) {
                      if(product.isInWishlist ?? false) {
                        setState(() {
                          product.isInWishlist = false;
                        });
                        final param = {
                          "product_id":product.id
                        };
                        context.read<WishListCubit>().deleteProductFromWishList(param);
                      }else{
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
                      },);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
