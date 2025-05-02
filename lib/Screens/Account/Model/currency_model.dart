class CurrencyModel {
  String? message;
  List<CurrencyData>? data;

  CurrencyModel({this.message, this.data});

  CurrencyModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <CurrencyData>[];
      json['data'].forEach((v) {
        data!.add(new CurrencyData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CurrencyData {
  String? code;
  String? name;

  CurrencyData({this.code, this.name});

  CurrencyData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    return data;
  }
}
