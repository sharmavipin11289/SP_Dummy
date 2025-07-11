import 'package:sanaa/CommonFiles/Model/meta_model.dart';

class MainCategory {
  String? message;
  List<MainCategoryData>? data;
  Meta? meta;

  MainCategory({this.message, this.data});

  MainCategory.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <MainCategoryData>[];
      json['data'].forEach((v) {
        data!.add(new MainCategoryData.fromJson(v));
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

class MainCategoryData {
  String? id;
  String? name;
  String? slug;
  String? image;
  String? imageUrl;

  MainCategoryData({this.id, this.name, this.slug, this.image, this.imageUrl});

  MainCategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    image = json['image'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['image'] = this.image;
    data['image_url'] = this.imageUrl;
    return data;
  }
}
