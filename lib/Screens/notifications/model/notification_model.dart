import '../../../CommonFiles/Model/meta_model.dart';

class NotificationModel {
  String? message;
  List<NotificationData>? notifications;
  Meta? meta;

  NotificationModel({this.message, this.notifications, this.meta});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      notifications = <NotificationData>[];
      json['data'].forEach((v) {
        notifications!.add(new NotificationData.fromJson(v));
      });
    }
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.notifications != null) {
      data['data'] = this.notifications!.map((v) => v.toJson()).toList();
    }
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    return data;
  }
}

class NotificationData {
  String? id;
  String? title;
  String? message;
  Null? readAt;

  NotificationData({this.id, this.title, this.message, this.readAt});

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    message = json['message'];
    readAt = json['read_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['message'] = this.message;
    data['read_at'] = this.readAt;
    return data;
  }
}

