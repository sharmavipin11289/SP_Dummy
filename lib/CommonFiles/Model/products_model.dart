import 'meta_model.dart';

class ProductsModel {
  String? message;
  List<ProductData>? data;
  Meta? meta;

  ProductsModel({this.message, this.data, this.meta});

  ProductsModel.fromJson(Map<String, dynamic> json, {String sourceType = 'product'}) {
    message = json['message'];
    if (json['data'] != null) {
      data = json['data']
          .map<ProductData>((v) => ProductData.fromJson(v, sourceType: sourceType))
          .toList();
    }
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data?.map((v) => v.toJson()).toList(),
      'meta': meta?.toJson(),
    };
  }
}


class ProductData {
  String? wishListId; // Optional: ID for wishList items
  String? id; // Product ID
  String? product_variant_id;
  String? name;
  String? businessName;
  String? discountPercentage;
  double? originalPrice; // Unified as double for consistency
  double? price; // Unified as double for consistency
  String? imageUrl;
  double? averageRating;
  bool? isInWishlist;
  bool? isOutOfStock;
  bool? isInCart;
  String? currency;
  String? type; // Will be set based on the `sourceType` parameter


  ProductData({
    this.wishListId,
    this.id,
    this.product_variant_id,
    this.name,
    this.businessName,
    this.discountPercentage,
    this.originalPrice,
    this.price,
    this.imageUrl,
    this.averageRating,
    this.isInWishlist,
    this.isOutOfStock,
    this.isInCart,
    this.currency,
    this.type,
  });

  ProductData.fromJson(Map<String, dynamic> json, {required String sourceType}) {
    // Set `type` based on sourceType
    type = sourceType;

    if (sourceType.toLowerCase() == 'wishlist') {
      // For wishList data
      wishListId = json['id']; // WishList-specific ID
      id = json['product_id']; // Product ID from wishList response
    } else {
      // For product data
      id = json['id']; // Product ID
    }
    product_variant_id = json['product_variant_id'];
    name = json['name'] ?? json['product_name']; // Handles name for both cases
    businessName = json['business_name'];
    discountPercentage = json['discount_percentage'];
    originalPrice = (json['original_price'] != null)
        ? double.tryParse(json['original_price'].toString())
        : null;
    price = (json['price'] != null)
        ? double.tryParse(json['price'].toString())
        : null;
    imageUrl = json['image_url'];
    final rating = json['average_rating'];
    averageRating = rating is int
        ? rating.toDouble()
        : rating is double
        ? rating
        : null;
    isInWishlist = json['is_in_wishlist'];
    isOutOfStock = json['is_out_of_stock'];
    isInCart = json['is_in_cart'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    return {
      'wish_list_id': wishListId,
      'id': id,
      'product_variant_id': product_variant_id,
      'name': name,
      'business_name': businessName,
      'discount_percentage': discountPercentage,
      'original_price': originalPrice,
      'price': price,
      'image_url': imageUrl,
      'average_rating': averageRating,
      'is_in_wishlist': isInWishlist,
      'is_out_of_stock': isOutOfStock,
      'is_in_cart': isInCart,
      'currency': currency,
      'type': type,
    };
  }
}
