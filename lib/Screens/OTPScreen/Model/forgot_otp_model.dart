class ForgotOtpModel {
  String? message;
  ForgotData? data;

  ForgotOtpModel({this.message, this.data});

  ForgotOtpModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new ForgotData.fromJson(json['data']) : null;
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

class ForgotData {
  String? resetToken;

  ForgotData({this.resetToken});

  ForgotData.fromJson(Map<String, dynamic> json) {
    resetToken = json['reset_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reset_token'] = this.resetToken;
    return data;
  }
}
