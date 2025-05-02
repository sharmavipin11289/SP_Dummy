class CartSummaryModel {
  String? message;
  CartSummaryData? data;

  CartSummaryModel({this.message, this.data});

  CartSummaryModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new CartSummaryData.fromJson(json['data']) : null;
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

class CartSummaryData {
  double? totalTaxAmount;
  double? subTotalPrice;
  double? totalPrice;
  String? couponDiscount;
  double? discountAmount;
  String? coupon_code;

  CartSummaryData({this.totalTaxAmount, this.subTotalPrice, this.totalPrice, this.couponDiscount, this.discountAmount, this.coupon_code});

  CartSummaryData.fromJson(Map<String, dynamic> json) {
    totalTaxAmount = (json['total_tax_amount'] is int) ? json['total_tax_amount'].toDouble() : json['total_tax_amount'];
    subTotalPrice = (json['sub_total_amount'] is int) ? json['sub_total_amount'].toDouble() : json['sub_total_amount'];
    totalPrice = (json['total_amount'] is int) ? json['total_amount'].toDouble() : json['total_amount'];
    couponDiscount = json['coupon_discount'] ?? '';
    discountAmount = (json['discount_amount'] is int) ? json['discount_amount'].toDouble() : json['discount_amount'];
    coupon_code = json['coupon_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_tax_amount'] = this.totalTaxAmount;
    data['sub_total_amount'] = this.subTotalPrice;
    data['total_amount'] = this.totalPrice;
    data['coupon_discount'] = this.couponDiscount;
    data['discount_amount'] = this.discountAmount;
    data['coupon_code'] = this.coupon_code;
    return data;
  }
}
