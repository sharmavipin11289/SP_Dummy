import 'package:sanaa/Screens/PaymentPage/model/checkout_summary_model.dart';

class PlaceOrderModel {
  String? message;
  PlaceOrderData? data;

  PlaceOrderModel({this.message, this.data});

  PlaceOrderModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new PlaceOrderData.fromJson(json['data']) : null;
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

class PlaceOrderData {
  /*String? orderId;
  String? orderNumber;
  String? totalAmount;
  String? currency;
  String? transactionId;
  CheckoutSummaryData? checkoutSummaryData;
  String? paymentMethod;*/
  String? payment_url;


  PlaceOrderData(
      {this.payment_url,
      /*  this.orderNumber,
        this.totalAmount,
        this.currency,
        this.transactionId*/});

  PlaceOrderData.fromJson(Map<String, dynamic> json) {
   /* orderId = json['order_id'];
    orderNumber = json['order_number'];
    totalAmount = json['total_amount'];
    currency = json['currency'];
    transactionId = json['transaction_id'];*/
    payment_url = json['payment_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
   /* data['order_id'] = this.orderId;
    data['order_number'] = this.orderNumber;
    data['total_amount'] = this.totalAmount;
    data['currency'] = this.currency;
    data['transaction_id'] = this.transactionId;*/
    data['payment_url'] = this.payment_url;
    return data;
  }
}
