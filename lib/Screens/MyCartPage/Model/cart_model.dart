import '../../../CommonFiles/Model/meta_model.dart';

class CartModel {
  String? message;
  List<CartData>? data;
  Meta? meta;

  CartModel({this.message, this.data, this.meta});

  CartModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <CartData>[];
      json['data'].forEach((v) {
        data!.add(new CartData.fromJson(v));
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

class CartData {
  String? id;
  String? productVariantId;
  String? productId;
  String? productName;
  String? imageUrl;
  String? colorVariantId;
  String? colorVariantName;
  String? sizeVariantId;
  String? sizeVariantName;
  double? price;
  double? total;
  int? quantity;
  String? currency;

  CartData(
      {this.id,
        this.productVariantId,
        this.productId,
        this.productName,
        this.imageUrl,
        this.colorVariantId,
        this.colorVariantName,
        this.sizeVariantId,
        this.sizeVariantName,
        this.price,
        this.total,
        this.quantity,
        this.currency});

  CartData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productVariantId = json['product_variant_id'];
    productId = json['product_id'];
    productName = json['product_name'];
    imageUrl = json['image_url'];
    colorVariantId = json['color_variant_id'];
    colorVariantName = json['color_variant_name'];
    sizeVariantId = json['size_variant_id'];
    sizeVariantName = json['size_variant_name'];
    price =  (json['price'] is int) ? json['price'].toDouble() : json['price'];
    total = (json['total'] is int) ? json['total'].toDouble() : json['total'];
    quantity = json['quantity'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_variant_id'] = this.productVariantId;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['image_url'] = this.imageUrl;
    data['color_variant_id'] = this.colorVariantId;
    data['color_variant_name'] = this.colorVariantName;
    data['size_variant_id'] = this.sizeVariantId;
    data['size_variant_name'] = this.sizeVariantName;
    data['price'] = this.price;
    data['total'] = this.total;
    data['quantity'] = this.quantity;
    data['currency'] = this.currency;
    return data;
  }
}


