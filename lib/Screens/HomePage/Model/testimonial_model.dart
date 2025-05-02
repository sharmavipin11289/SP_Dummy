import '../../../CommonFiles/Model/meta_model.dart';

class TestimonialModal {
  String? message;
  List<Testimonial>? data;
  Meta? meta;

  TestimonialModal({this.message, this.data, this.meta});

  TestimonialModal.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Testimonial>[];
      json['data'].forEach((v) {
        data!.add(new Testimonial.fromJson(v));
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

class Testimonial {
  String? id;
  String? customerName;
  String? customerProfilePictureUrl;
  String? review;
  int? rating;

  Testimonial(
      {this.id,
        this.customerName,
        this.customerProfilePictureUrl,
        this.review,
        this.rating});

  Testimonial.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerName = json['customer_name'];
    customerProfilePictureUrl = json['customer_profile_picture_url'];
    review = json['review'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_name'] = this.customerName;
    data['customer_profile_picture_url'] = this.customerProfilePictureUrl;
    data['review'] = this.review;
    data['rating'] = this.rating;
    return data;
  }
}


