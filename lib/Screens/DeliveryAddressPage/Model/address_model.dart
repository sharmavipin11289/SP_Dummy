import '../../../CommonFiles/Model/meta_model.dart';

class AddressModel {
  String? message;
  List<AddressData>? data;
  Meta? meta;

  AddressModel({this.message, this.data, this.meta});

  AddressModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <AddressData>[];
      json['data'].forEach((v) {
        data!.add(new AddressData.fromJson(v));
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

class AddressData {
  String? id;
  String? customerId;
  String? firstName;
  String? lastName;
  String? companyName;
  String? address;
  String? country;
  String? regionState;
  String? city;
  String? zipCode;
  String? email;
  String? phoneNumber;
  bool? isMainAddress;

  AddressData(
      {this.id,
        this.customerId,
        this.firstName,
        this.lastName,
        this.companyName,
        this.address,
        this.country,
        this.regionState,
        this.city,
        this.zipCode,
        this.email,
        this.phoneNumber,
        this.isMainAddress});

  AddressData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    companyName = json['company_name'];
    address = json['address'];
    country = json['country'];
    regionState = json['region_state'];
    city = json['city'];
    zipCode = json['zip_code'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    isMainAddress = json['is_main_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_id'] = this.customerId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['company_name'] = this.companyName;
    data['address'] = this.address;
    data['country'] = this.country;
    data['region_state'] = this.regionState;
    data['city'] = this.city;
    data['zip_code'] = this.zipCode;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['is_main_address'] = this.isMainAddress;
    return data;
  }
}


