import '../../../CommonFiles/Model/meta_model.dart';

class ShopModel {
  String? message;
  List<ShopData>? data;
  Meta? meta;

  ShopModel({this.message, this.data, this.meta});

  ShopModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <ShopData>[];
      json['data'].forEach((v) {
        data!.add(new ShopData.fromJson(v));
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

class ShopData {
  String? id;
  String? name;
  String? email;
  String? contactNumber;
  String? businessName;
  String? businessLogo;
  String? businessLogoUrl;
  bool? verified;

  ShopData(
      {this.id,
        this.name,
        this.email,
        this.contactNumber,
        this.businessName,
        this.businessLogo,
        this.businessLogoUrl, this.verified});

  ShopData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    contactNumber = json['contact_number'];
    businessName = json['business_name'];
    businessLogo = json['business_logo'];
    businessLogoUrl = json['business_logo_url'];
    verified = json['verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['contact_number'] = this.contactNumber;
    data['business_name'] = this.businessName;
    data['business_logo'] = this.businessLogo;
    data['business_logo_url'] = this.businessLogoUrl;
    data['verified'] = this.verified;
    return data;
  }
}

