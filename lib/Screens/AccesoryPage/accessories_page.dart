import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanaa/CommonFiles/Model/products_model.dart';
import 'package:sanaa/CommonWidgets/banner_widget.dart';
import 'package:sanaa/CommonWidgets/product_card.dart';
import 'package:sanaa/CommonWidgets/recommended_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../CommonFiles/cubit/common_cubit.dart';
import '../../CommonFiles/text_style.dart';

class AccessoriesPage extends StatefulWidget {
  const AccessoriesPage({super.key});

  @override
  State<AccessoriesPage> createState() => _AccessoriesPageState();
}

class _AccessoriesPageState extends State<AccessoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    color: Colors.black,
                    width: 36,
                    height: 36,
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 19,
                    ),
                  ),
                ),
                Spacer(),
                Text(
                  AppLocalizations.of(context)?.accessories ?? 'Accessories',
                  style: FontStyles.getStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Spacer(),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
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
                        Icon(
                          Icons.sort_by_alpha_rounded,
                          color: Color(0xFFC1DAC1),
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
                SizedBox(
                  width: 16,
                ),
                Expanded(
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
                        Icon(
                          Icons.sort_by_alpha_rounded,
                          color: Color(0xFFC1DAC1),
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
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Two columns
                    crossAxisSpacing: 20, // Horizontal spacing
                    mainAxisSpacing: 20, // Vertical spacing
                    childAspectRatio: 0.85),
                itemCount: 20, // Number of items in the grid
                itemBuilder: (context, index) {
                  return ProductCard(
                    product: ProductData(),
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
                  );
                },
              ),
            ),
          ],
        ),
      )),
    );
  }
}
