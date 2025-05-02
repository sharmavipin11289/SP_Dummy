import 'package:sanaa/Screens/HomePage/Model/shop_model.dart';

class ProductDetailModel {
  String? message;
  ProductDetail? data;

  ProductDetailModel({this.message, this.data});

  ProductDetailModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new ProductDetail.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ProductDetail {
  String? id;
  String? product_variant_id;
  String? name;
  String? additionalInformation;
  String? description;
  List<String>? images;
  bool? isInWishlist;
  bool? isInCart;
  bool? isOutOfStock;
  int? ratingCount;
  double? averageRating;
  String? discountPercentage;
  double? originalPrice;
  double? price;
  String? currency;
  ShopData? vendorDetails;
  List<SizeVariants>? sizeVariants;
  List<ColorVariants>? colorVariants;

  ProductDetail(
      {this.id,
        this.product_variant_id,
        this.name,
        this.additionalInformation,
        this.description,
        this.images,
        this.isInWishlist,
        this.isInCart,
        this.isOutOfStock,
        this.ratingCount,
        this.averageRating,
        this.discountPercentage,
        this.originalPrice,
        this.price,
        this.currency,
        this.vendorDetails,
        this.sizeVariants,
        this.colorVariants});

  ProductDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product_variant_id = json['product_variant_id'];
    name = json['name'];
    additionalInformation = json['additional_information'];
    description = json['description'];
    images = json['images'].cast<String>();
    isInWishlist = json['is_in_wishlist'];
    isInCart = json['is_in_cart'];
    isOutOfStock = json['is_out_of_stock'];
    ratingCount = json['rating_count'];
    averageRating = (json['average_rating'] is int) ? json['average_rating'].toDouble() : json['average_rating'];
    discountPercentage = json['discount_percentage'];
    originalPrice = (json['original_price'] is int) ? json['original_price'].toDouble() : json['original_price'];
    price = (json['price'] is int) ? json['price'].toDouble() : json['price'];
    currency = json['currency'];
    vendorDetails = json['vendor_details'] != null
        ? new ShopData.fromJson(json['vendor_details'])
        : null;
    if (json['size_variants'] != null) {
      sizeVariants = <SizeVariants>[];
      json['size_variants'].forEach((v) {
        sizeVariants!.add(new SizeVariants.fromJson(v));
      });
    }
    if (json['color_variants'] != null) {
      colorVariants = <ColorVariants>[];
      json['color_variants'].forEach((v) {
        colorVariants!.add(new ColorVariants.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_variant_id'] = this.product_variant_id;
    data['name'] = this.name;
    data['additional_information'] = this.additionalInformation;
    data['description'] = this.description;
    data['images'] = this.images;
    data['is_in_wishlist'] = this.isInWishlist;
    data['is_in_cart'] = this.isInCart;
    data['is_out_of_stock'] = this.isOutOfStock;
    data['rating_count'] = this.ratingCount;
    data['average_rating'] = this.averageRating;
    data['discount_percentage'] = this.discountPercentage;
    data['original_price'] = this.originalPrice;
    data['price'] = this.price;
    data['currency'] = this.currency;
    if (this.vendorDetails != null) {
      data['vendor_details'] = this.vendorDetails!.toJson();
    }
    if (this.sizeVariants != null) {
      data['size_variants'] =
          this.sizeVariants!.map((v) => v.toJson()).toList();
    }
    if (this.colorVariants != null) {
      data['color_variants'] =
          this.colorVariants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

/*class VendorDetails {
  String? id;
  String? businessName;
  String? businessLogoUrl;
  bool? verified;

  VendorDetails(
      {this.id, this.businessName, this.businessLogoUrl, this.verified});

  VendorDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    businessName = json['business_name'];
    businessLogoUrl = json['business_logo_url'];
    verified = json['verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['business_name'] = this.businessName;
    data['business_logo_url'] = this.businessLogoUrl;
    data['verified'] = this.verified;
    return data;
  }
}*/

class SizeVariants {
  String? id;
  String? name;

  SizeVariants({this.id, this.name});

  SizeVariants.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class ColorVariants {
  String? id;
  String? name;
  String? value;

  ColorVariants({this.id, this.name, this.value});

  ColorVariants.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}
