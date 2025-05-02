import '../../../CommonFiles/Model/meta_model.dart';

class BannerModel {
  String? message;
  List<BannerData>? data;
  Meta? meta;

  BannerModel({this.message, this.data, this.meta});

  BannerModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <BannerData>[];
      json['data'].forEach((v) {
        data!.add(new BannerData.fromJson(v));
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

class BannerData {
  String? id;
  String? title;
  String? shortDescription;
  String? image;
  String? buttonTitle;
  String? redirectUrl;
  String? imageUrl;

  BannerData(
      {this.id,
        this.title,
        this.shortDescription,
        this.image,
        this.buttonTitle,
        this.redirectUrl,
        this.imageUrl});

  BannerData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    shortDescription = json['short_description'];
    image = json['image'];
    buttonTitle = json['button_title'];
    redirectUrl = json['redirect_url'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['short_description'] = this.shortDescription;
    data['image'] = this.image;
    data['button_title'] = this.buttonTitle;
    data['redirect_url'] = this.redirectUrl;
    data['image_url'] = this.imageUrl;
    return data;
  }
}


