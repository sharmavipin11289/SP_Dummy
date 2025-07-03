import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:sanaa/CommonFiles/Model/products_model.dart';
import 'package:sanaa/CommonFiles/common_variables.dart';
import 'package:sanaa/CommonFiles/image_file.dart';
import 'package:sanaa/CommonFiles/text_style.dart';
import 'package:sanaa/Navigation/navigation_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductCard extends StatefulWidget {
  ProductData product;
  Function? onTapLikeIcon;
  Function? onTapCartIcon;
  Function? onTapProduct;

  ProductCard({required this.product, this.onTapLikeIcon = null, this.onTapCartIcon = null, this.onTapProduct = null});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  Widget _buildPriceText() {
    final hasDiscount = (widget.product.discountPercentage ?? '0').isNotEmpty && double.parse(widget.product.discountPercentage ?? '0.0') > 0;
    final isPriceSmall = (widget.product.price ?? 0) < (widget.product.originalPrice ?? 0);
    print("hasDiscount $hasDiscount");
    print("hasSmall $isPriceSmall");
    return Text(
      '${widget.product.currency ?? 'KES'} ${hasDiscount && isPriceSmall ? (widget.product.price?.toString() ?? '0') : (hasDiscount && !(isPriceSmall)) ? (widget.product.originalPrice?.toString() ?? '0') : (widget.product.price?.toString() ?? '0')}',
      style: FontStyles.getStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF006600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onTapProduct != null) {
          widget.onTapProduct!(widget.product.id);
        } else {
          NavigationService.navigateTo('/productDetailPage', arguments: widget.product.id);
        }
      },
      child: Card(
        elevation: 1,
        color: Colors.white,
        child: Container(
          color: Colors.transparent,
          height: 188,
          width: 148,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                height: 115,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.network(
                        widget.product.imageUrl ?? dummyImageUrl,
                        height: 115,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Favorite Icon
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          if (widget.onTapLikeIcon != null) {
                            widget.onTapLikeIcon!(widget.product);
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(11),
                          child: Container(
                            width: 22,
                            height: 22,
                            color: Colors.white,
                            child: Icon(
                              (widget.product.isInWishlist ?? false) ? Icons.favorite : Icons.favorite_border,
                              color: Colors.red,
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (widget.product.isOutOfStock == false)
                      Positioned(
                        top: 80,
                        right: 8,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(11),
                          child: GestureDetector(
                            onTap: () {
                              if (widget.onTapCartIcon != null) {
                                widget.onTapCartIcon!(widget.product);
                              }
                            },
                            child: Container(
                              width: 22,
                              height: 22,
                              color: Colors.black,
                              child: Image.asset(
                                cart,
                                width: 20,
                                height: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8),
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Product Title
                      Text(
                        widget.product.name ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: FontStyles.getStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      // Subtitle
                      Text(
                        (AppLocalizations.of(context)?.by ?? 'by ') + (widget.product.businessName ?? ''),
                        style: FontStyles.getStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF7A7A7A),
                        ),
                      ),

                      // Rating and Price Row
                      Row(
                        children: [
                          StarRating(
                            size: 10,
                            rating: widget.product.averageRating ?? 0,
                            allowHalfRating: true,
                            onRatingChanged: (rating) {},
                            color: Color(0xFFFFCE00),
                            emptyIcon: Icons.star,
                            halfFilledIcon: Icons.star_half_outlined,
                            filledIcon: Icons.star,
                          ),
                        ],
                      ),

                      // Price
                      _buildPriceText()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
