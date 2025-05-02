class paymentMethodModel {
  String? message;
  PaymentData? data;

  paymentMethodModel({this.message, this.data});

  paymentMethodModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new PaymentData.fromJson(json['data']) : null;
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

class PaymentData {
  List<ShippingMethods>? shippingMethods;
  List<PaymentMethods>? paymentMethods;

  PaymentData({this.shippingMethods, this.paymentMethods});

  PaymentData.fromJson(Map<String, dynamic> json) {
    if (json['shipping_methods'] != null) {
      shippingMethods = <ShippingMethods>[];
      json['shipping_methods'].forEach((v) {
        shippingMethods!.add(new ShippingMethods.fromJson(v));
      });
    }
    if (json['payment_methods'] != null) {
      paymentMethods = <PaymentMethods>[];
      json['payment_methods'].forEach((v) {
        paymentMethods!.add(new PaymentMethods.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.shippingMethods != null) {
      data['shipping_methods'] =
          this.shippingMethods!.map((v) => v.toJson()).toList();
    }
    if (this.paymentMethods != null) {
      data['payment_methods'] =
          this.paymentMethods!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShippingMethods {
  String? name;
  String? cost;

  ShippingMethods({this.name, this.cost});

  ShippingMethods.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    cost = json['cost'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['cost'] = this.cost.toString();
    return data;
  }
}

class PaymentMethods {
  String? id;
  String? image;
  String? option;
  String? name;
  String? requiresPhoneNumber;
  String? imageUrl;

  PaymentMethods(
      {this.id,
        this.image,
        this.option,
        this.name,
        this.requiresPhoneNumber,
        this.imageUrl});

  PaymentMethods.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    option = json['option'];
    name = json['name'];
    requiresPhoneNumber = json['requires_phone_number'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['option'] = this.option;
    data['name'] = this.name;
    data['requires_phone_number'] = this.requiresPhoneNumber;
    data['image_url'] = this.imageUrl;
    return data;
  }
}
