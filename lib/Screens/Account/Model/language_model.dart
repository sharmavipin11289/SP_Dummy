import '../../../CommonFiles/Model/meta_model.dart';

class LanguageModel {
  String? message;
  List<LanguageData>? data;
  Meta? meta;

  LanguageModel({this.message, this.data, this.meta});

  LanguageModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <LanguageData>[];
      json['data'].forEach((v) {
        data!.add(new LanguageData.fromJson(v));
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

class LanguageData {
  String? id;
  String? name;
  String? locale;
  String? createdAt;

  LanguageData({this.id, this.name, this.locale, this.createdAt});

  LanguageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    locale = json['locale'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['locale'] = this.locale;
    data['created_at'] = this.createdAt;
    return data;
  }
}

