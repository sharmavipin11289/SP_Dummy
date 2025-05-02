import '../../../CommonFiles/Model/meta_model.dart';

class CouponModel {
  String? message;
  List<CouponData>? data;
  Meta? meta;

  CouponModel({this.message, this.data, this.meta});

  CouponModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <CouponData>[];
      json['data'].forEach((v) {
        data!.add(new CouponData.fromJson(v));
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

class CouponData {
  String? id;
  String? name;
  String? code;
  String? offerTill;
  String? discountType;

  CouponData({this.id, this.name, this.code, this.offerTill, this.discountType});

  CouponData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    offerTill = json['offer_till'];
    discountType = json['discount_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['offer_till'] = this.offerTill;
    data['discount_type'] = this.discountType;
    return data;
  }
}


