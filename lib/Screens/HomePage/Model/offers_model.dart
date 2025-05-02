import '../../../CommonFiles/Model/meta_model.dart';

class OffersModel {
  String? message;
  List<OfferData>? data;
  Meta? meta;

  OffersModel({this.message, this.data, this.meta});

  OffersModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <OfferData>[];
      json['data'].forEach((v) {
        data!.add(new OfferData.fromJson(v));
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

class OfferData {
  String? id;
  String? title;
  String? image;
  String? offerTill;
  String? imageUrl;

  OfferData({this.id, this.title, this.image, this.offerTill, this.imageUrl});

  OfferData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    offerTill = json['offerTill'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['image'] = this.image;
    data['offerTill'] = this.offerTill;
    data['image_url'] = this.imageUrl;
    return data;
  }
}


