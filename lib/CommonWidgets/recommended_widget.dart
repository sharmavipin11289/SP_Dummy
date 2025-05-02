import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sanaa/CommonFiles/Model/products_model.dart';
import 'package:sanaa/CommonWidgets/product_card.dart';
import 'package:sanaa/Navigation/navigation_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../CommonFiles/text_style.dart';

class RecommendedWidget extends StatefulWidget {
  List<ProductData> products;
  Function onTapLikeIcon;
  Function onTapCartIcon;

  RecommendedWidget({super.key, required this.products, required this.onTapLikeIcon, required this.onTapCartIcon});

  @override
  State<RecommendedWidget> createState() => _RecommendedWidgetState();
}

class _RecommendedWidgetState extends State<RecommendedWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)?.recommendedForYou ?? 'Recommended for you',
                style: FontStyles.getStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () {
                  final args = {
                    'title': AppLocalizations.of(context)?.recommendedForYou ?? 'Recommended for you',
                    'view': 'recommended',
                  };
                  NavigationService.navigateTo('/excitingOffer', arguments: args);
                  //NavigationService.navigateTo('/recommendedPage');
                },
                child: Text(
                  AppLocalizations.of(context)?.seeAll ?? 'See All',
                  style: FontStyles.getStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF318531),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 14,
        ),
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var product in widget.products)
                  ProductCard(
                    product: product,
                    onTapLikeIcon: widget.onTapLikeIcon,
                    onTapCartIcon: widget.onTapCartIcon,
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
