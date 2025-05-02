import '../../../CommonFiles/Model/meta_model.dart';

class WishListModel {
  String? message;
  List<WishListData>? data;
  Meta? meta;

  WishListModel({this.message, this.data, this.meta});

  WishListModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <WishListData>[];
      json['data'].forEach((v) {
        data!.add(new WishListData.fromJson(v));
      });
    }
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    return data;
  }
}

class WishListData {
  String? id;
  String? productId;
  String? productVariantId;
  String? productName;
  String? businessName;
  String? discountPercentage;
  double? originalPrice;
  double? price;
  String? imageUrl;
  int? averageRating;
  bool? isInWishlist;
  bool? isInCart;
  bool? isOutOfStock;
  String? currency;

  WishListData(
      {this.id,
        this.productId,
        this.productVariantId,
        this.productName,
        this.businessName,
        this.discountPercentage,
        this.originalPrice,
        this.price,
        this.imageUrl,
        this.averageRating,
        this.isInWishlist,
        this.isInCart,
        this.isOutOfStock,
        this.currency});

  WishListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    productVariantId = json['product_variant_id'];
    productName = json['product_name'];
    businessName = json['business_name'];
    discountPercentage = json['discount_percentage'];
    originalPrice = (json['original_price'] is int) ? json['original_price'].toDouble() : json['original_price'];
    price = (json['price'] is int) ? json['price'].toDouble() : json['price'];
    imageUrl = json['image_url'];
    averageRating = json['average_rating'];
    isInWishlist = json['is_in_wishlist'];
    isInCart = json['is_in_cart'];
    isOutOfStock = json['is_out_of_stock'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['product_variant_id'] = this.productVariantId;
    data['product_name'] = this.productName;
    data['business_name'] = this.businessName;
    data['discount_percentage'] = this.discountPercentage;
    data['original_price'] = this.originalPrice;
    data['price'] = this.price;
    data['image_url'] = this.imageUrl;
    data['average_rating'] = this.averageRating;
    data['is_in_wishlist'] = this.isInWishlist;
    data['is_in_cart'] = this.isInCart;
    data['is_out_of_stock'] = this.isOutOfStock;
    data['currency'] = this.currency;
    return data;
  }
}


