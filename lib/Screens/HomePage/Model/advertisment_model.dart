import '../../../CommonFiles/Model/meta_model.dart';

class AdvertismentModel {
  String? message;
  List<AdvertismentData>? data;
  Meta? meta;

  AdvertismentModel({this.message, this.data, this.meta});

  AdvertismentModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <AdvertismentData>[];
      json['data'].forEach((v) {
        data!.add(new AdvertismentData.fromJson(v));
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

class AdvertismentData {
  String? id;
  String? script;
  String? page;
  String? position;
  String? createdAt;

  AdvertismentData({this.id, this.script, this.page, this.position, this.createdAt});

  AdvertismentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    script = json['script'];
    page = json['page'];
    position = json['position'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['script'] = this.script;
    data['page'] = this.page;
    data['position'] = this.position;
    data['created_at'] = this.createdAt;
    return data;
  }
}
