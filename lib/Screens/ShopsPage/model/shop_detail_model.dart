import 'package:sanaa/Screens/HomePage/Model/main_category_model.dart';

class ShopDetailModel {
  String? message;
  ShopDetail? data;

  ShopDetailModel({this.message, this.data});

  ShopDetailModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new ShopDetail.fromJson(json['data']) : null;
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

class ShopDetail {
  String? id;
  String? name;
  String? email;
  String? contactNumber;
  String? description;
  String? businessName;
  String? businessEmail;
  String? businessLogo;
  String? businessLogoUrl;
  List<MainCategoryData>? preferredCategories;

  ShopDetail(
      {this.id,
        this.name,
        this.email,
        this.contactNumber,
        this.description,
        this.businessName,
        this.businessEmail,
        this.businessLogo,
        this.businessLogoUrl,
        this.preferredCategories});

  ShopDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    contactNumber = json['contact_number'];
    description = json['description'];
    businessName = json['business_name'];
    businessEmail = json['business_email'];
    businessLogo = json['business_logo'];
    businessLogoUrl = json['business_logo_url'];
    if (json['preferred_categories'] != null) {
      preferredCategories = <MainCategoryData>[];
      json['preferred_categories'].forEach((v) {
        preferredCategories!.add(new MainCategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['contact_number'] = this.contactNumber;
    data['description'] = this.description;
    data['business_name'] = this.businessName;
    data['business_email'] = this.businessEmail;
    data['business_logo'] = this.businessLogo;
    data['business_logo_url'] = this.businessLogoUrl;
    if (this.preferredCategories != null) {
      data['preferred_categories'] =
          this.preferredCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


