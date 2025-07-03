class CommonResponse {
  String? message;
  dynamic data; // Can be null, an object, or a list
  String? token;
  List<dynamic>? extra;
  CommonResponse({this.message, this.data, this.token, this.extra});

  // Factory constructor to handle deserialization
  factory CommonResponse.fromJson(Map<String, dynamic> json) {
    return CommonResponse(
      message: json['message'],
      data: json.containsKey('data') ? json['data'] : null,
      token: json.containsKey('token') ? json['token'] : null,
      extra: json.containsKey('extra') ? json['extra'] : null
    );
  }

  // Method to handle serialization
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = <String, dynamic>{};
    if (message != null) {
      result['message'] = message;
    }
    if (data != null) {
      result['data'] = data;
    }
    if (token != null) {
      result['token'] = token;
    }
    if (extra != null) {
      result['extra'] = extra;
    }
    return result;
  }
}



class OrderSummaryModel {
  String? message;
  OrderData? data;

  OrderSummaryModel({this.message, this.data});

  OrderSummaryModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new OrderData.fromJson(json['data']) : null;
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

class OrderData {
  List<OrderItems>? items;

  OrderData({this.items});

  OrderData.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <OrderItems>[];
      json['items'].forEach((v) {
        items!.add(new OrderItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderItems {
  String? id;
  String? productVariantId;
  String? productId;
  String? productName;
  String? imageUrl;
  String? colorVariantId;
  String? colorVariantName;
  String? sizeVariantId;
  String? sizeVariantName;
  int? price;
  int? total;
  int? quantity;
  String? currency;

  OrderItems(
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

  OrderItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productVariantId = json['product_variant_id'];
    productId = json['product_id'];
    productName = json['product_name'];
    imageUrl = json['image_url'];
    colorVariantId = json['color_variant_id'];
    colorVariantName = json['color_variant_name'];
    sizeVariantId = json['size_variant_id'];
    sizeVariantName = json['size_variant_name'];
    price = json['price'];
    total = json['total'];
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
