class CheckoutSummaryModel {
  String? message;
  CheckoutSummaryData? data;

  CheckoutSummaryModel({this.message, this.data});

  CheckoutSummaryModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new CheckoutSummaryData.fromJson(json['data']) : null;
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

class CheckoutSummaryData {
  List<CheckoutItem>? items;
  double? totalTaxAmount;
  double? subTotalAmount;
  double? totalAmount;
  String? couponType;
  String? couponName;
  String? couponCode;
  String? couponDiscount;
  double? discountAmount;
  double? shippingAmount;

  CheckoutSummaryData(
      {this.items,
        this.totalTaxAmount,
        this.subTotalAmount,
        this.totalAmount,
        this.couponType,
        this.couponName,
        this.couponCode,
        this.couponDiscount,
        this.discountAmount, this.shippingAmount});

  CheckoutSummaryData.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <CheckoutItem>[];
      json['items'].forEach((v) {
        items!.add(new CheckoutItem.fromJson(v));
      });
    }
    totalTaxAmount = (json['total_tax_amount'] is int) ? json['total_tax_amount'].toDouble() : json['total_tax_amount'];
    subTotalAmount = (json['sub_total_amount'] is int) ? json['sub_total_amount'].toDouble() : json['sub_total_amount'];
    totalAmount = (json['total_amount'] is int) ? json['total_amount'].toDouble() : json['total_amount'];
    couponType = json['coupon_type'];
    couponName = json['coupon_name'];
    couponCode = json['coupon_code'];
    couponDiscount = json['coupon_discount'];
    discountAmount = (json['discount_amount'] is int) ? json['discount_amount'].toDouble() : json['discount_amount'];
    shippingAmount = (json['shipping_amount'] is int) ? json['shipping_amount'].toDouble() : json['shipping_amount'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['total_tax_amount'] = this.totalTaxAmount;
    data['sub_total_amount'] = this.subTotalAmount;
    data['total_amount'] = this.totalAmount;
    data['coupon_type'] = this.couponType;
    data['coupon_name'] = this.couponName;
    data['coupon_code'] = this.couponCode;
    data['coupon_discount'] = this.couponDiscount;
    data['discount_amount'] = this.discountAmount;
    data['shipping_amount'] = this.shippingAmount;
    return data;
  }
}

class CheckoutItem {
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

  CheckoutItem(
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

  CheckoutItem.fromJson(Map<String, dynamic> json) {
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
    total =  (json['total'] is int) ? json['total'].toDouble() :json['total'];
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
