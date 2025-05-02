class OrderDetailModel {
  String? message;
  OrderDetailData? data;

  OrderDetailModel({this.message, this.data});

  OrderDetailModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new OrderDetailData.fromJson(json['data']) : null;
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

class OrderDetailData {
  OrderDetails? orderDetails;
  List<OrderItems>? orderItems;
  DeliveryAddress? deliveryAddress;

  OrderDetailData({this.orderDetails, this.orderItems, this.deliveryAddress});

  OrderDetailData.fromJson(Map<String, dynamic> json) {
    orderDetails = json['order_details'] != null
        ? new OrderDetails.fromJson(json['order_details'])
        : null;
    if (json['order_items'] != null) {
      orderItems = <OrderItems>[];
      json['order_items'].forEach((v) {
        orderItems!.add(new OrderItems.fromJson(v));
      });
    }
    deliveryAddress = json['delivery_address'] != null
        ? new DeliveryAddress.fromJson(json['delivery_address'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderDetails != null) {
      data['order_details'] = this.orderDetails!.toJson();
    }
    if (this.orderItems != null) {
      data['order_items'] = this.orderItems!.map((v) => v.toJson()).toList();
    }
    if (this.deliveryAddress != null) {
      data['delivery_address'] = this.deliveryAddress!.toJson();
    }
    return data;
  }
}

class OrderDetails {
  String? id;
  String? number;
  String? currency;
  String? date;
  String? time;
  int? totalProducts;
  String? subtotalAmount;
  String? discountAmount;
  String? taxAmount;
  String? tax;
  String? shipping;
  String? totalAmount;

  OrderDetails(
      {this.id,
        this.number,
        this.currency,
        this.date,
        this.time,
        this.totalProducts,
        this.subtotalAmount,
        this.discountAmount,
        this.taxAmount,
        this.tax,
        this.shipping,
        this.totalAmount});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
    currency = json['currency'];
    date = json['date'];
    time = json['time'];
    totalProducts = json['total_products'];
    subtotalAmount = json['subtotal_amount'];
    discountAmount = json['discount_amount'];
    taxAmount = json['tax_amount'];
    tax = json['tax'];
    shipping = json['shipping'];
    totalAmount = json['total_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['number'] = this.number;
    data['currency'] = this.currency;
    data['date'] = this.date;
    data['time'] = this.time;
    data['total_products'] = this.totalProducts;
    data['subtotal_amount'] = this.subtotalAmount;
    data['discount_amount'] = this.discountAmount;
    data['tax_amount'] = this.taxAmount;
    data['tax'] = this.tax;
    data['shipping'] = this.shipping;
    data['total_amount'] = this.totalAmount;
    return data;
  }
}

class OrderItems {
  String? id;
  String? orderId;
  int? quantity;
  String? pricePerUnit;
  String? discountAmount;
  String? taxAmount;
  String? tax;
  String? totalAmount;
  String? status;
  OrderProduct? product;

  OrderItems(
      {this.id,
        this.orderId,
        this.quantity,
        this.pricePerUnit,
        this.discountAmount,
        this.taxAmount,
        this.tax,
        this.totalAmount,
        this.status,
        this.product});

  OrderItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    quantity = json['quantity'];
    pricePerUnit = json['price_per_unit'];
    discountAmount = json['discount_amount'];
    taxAmount = json['tax_amount'];
    tax = json['tax'];
    totalAmount = json['total_amount'];
    status = json['status'];
    product =
    json['product'] != null ? new OrderProduct.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['quantity'] = this.quantity;
    data['price_per_unit'] = this.pricePerUnit;
    data['discount_amount'] = this.discountAmount;
    data['tax_amount'] = this.taxAmount;
    data['tax'] = this.tax;
    data['total_amount'] = this.totalAmount;
    data['status'] = this.status;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}

class OrderProduct {
  String? id;
  String? name;
  String? businessName;
  String? image;
  String? colorVariantId;
  String? colorVariantName;
  String? sizeVariantId;
  String? sizeVariantName;

  OrderProduct(
      {this.id,
        this.name,
        this.businessName,
        this.image,
        this.colorVariantId,
        this.colorVariantName,
        this.sizeVariantId,
        this.sizeVariantName});

  OrderProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    businessName = json['business_name'];
    image = json['image'];
    colorVariantId = json['color_variant_id'];
    colorVariantName = json['color_variant_name'];
    sizeVariantId = json['size_variant_id'];
    sizeVariantName = json['size_variant_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['business_name'] = this.businessName;
    data['image'] = this.image;
    data['color_variant_id'] = this.colorVariantId;
    data['color_variant_name'] = this.colorVariantName;
    data['size_variant_id'] = this.sizeVariantId;
    data['size_variant_name'] = this.sizeVariantName;
    return data;
  }
}

class DeliveryAddress {
  String? name;
  String? address;
  String? email;
  String? phoneNumber;
  String? deliveryInstruction;

  DeliveryAddress(
      {this.name,
        this.address,
        this.email,
        this.phoneNumber,
        this.deliveryInstruction});

  DeliveryAddress.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    deliveryInstruction = json['delivery_instruction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['address'] = this.address;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['delivery_instruction'] = this.deliveryInstruction;
    return data;
  }
}
