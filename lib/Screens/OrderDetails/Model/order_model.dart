import '../../../CommonFiles/Model/meta_model.dart';

class OrdersModel {
  String? message;
  List<Order>? data;
  Meta? meta;

  OrdersModel({this.message, this.data, this.meta});

  OrdersModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Order>[];
      json['data'].forEach((v) {
        data!.add(new Order.fromJson(v));
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

class Order {
  String? id;
  String? orderNumber;
  String? currency;
  String? totalAmount;
  String? paymentMode;
  String? date;
  String? status;

  Order(
      {this.id,
        this.orderNumber,
        this.currency,
        this.totalAmount,
        this.paymentMode,
        this.date,
        this.status});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['order_number'];
    currency = json['currency'];
    totalAmount = json['total_amount'];
    paymentMode = json['payment_mode'];
    date = json['date'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_number'] = this.orderNumber;
    data['currency'] = this.currency;
    data['total_amount'] = this.totalAmount;
    data['payment_mode'] = this.paymentMode;
    data['date'] = this.date;
    data['status'] = this.status;
    return data;
  }
}


