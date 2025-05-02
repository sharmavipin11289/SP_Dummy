import '../../../CommonFiles/Model/meta_model.dart';

class ProductReviewModel {
  String? message;
  List<ProductReview>? data;
  Meta? meta;

  ProductReviewModel({this.message, this.data, this.meta});

  ProductReviewModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <ProductReview>[];
      json['data'].forEach((v) {
        data!.add(new ProductReview.fromJson(v));
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

class ProductReview {
  String? id;
  String? customerName;
  String? customerProfilePictureUrl;
  String? review;
  int? rating;
  String? reviewedAt;

  ProductReview(
      {this.id,
        this.customerName,
        this.customerProfilePictureUrl,
        this.review,
        this.rating,
        this.reviewedAt});

  ProductReview.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerName = json['customer_name'];
    customerProfilePictureUrl = json['customer_profile_picture_url'];
    review = json['review'];
    rating = json['rating'];
    reviewedAt = json['reviewed_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_name'] = this.customerName;
    data['customer_profile_picture_url'] = this.customerProfilePictureUrl;
    data['review'] = this.review;
    data['rating'] = this.rating;
    data['reviewed_at'] = this.reviewedAt;
    return data;
  }
}


