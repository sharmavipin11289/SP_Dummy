import 'package:sanaa/CommonFiles/Model/products_model.dart';
import 'package:sanaa/Screens/ProductDetailPage/model/product_review_model.dart';
import 'package:sanaa/Screens/ShopsPage/model/shop_detail_model.dart';

import '../../HomePage/Model/shop_model.dart';

abstract class ShopsState {}

class ShopInitial extends ShopsState {}

class ShopsLoading extends ShopsState {}
class ShopsSuccess extends ShopsState {
  List<ShopData> shopsData;
  ShopsSuccess(this.shopsData);
}
class ShopsFailed extends ShopsState {
  final String error;
  ShopsFailed(this.error);
}


class ShopDetailSuccess extends ShopsState {
  ShopDetail? shopData;
  ShopDetailSuccess(this.shopData);
}
class ShopDetailFailed extends ShopsState {
  final String error;
  ShopDetailFailed(this.error);
}



class ShopProductLoading extends ShopsState {}
class ShopProductSuccess extends ShopsState {
  List<ProductData> products;
  ShopProductSuccess(this.products);
}
class ShopProductFailed extends ShopsState {
  final String error;
  ShopProductFailed(this.error);
}


class ShopReviewLoading extends ShopsState {}
class ShopReviewSuccess extends ShopsState {
  List<ProductReview> reviews;
  ShopReviewSuccess(this.reviews);
}
class ShopReviewFailed extends ShopsState {
  final String error;
  ShopReviewFailed(this.error);
}


class SubmitReviewLoading extends ShopsState {}
class SubmitReviewSuccess extends ShopsState {}
class SubmitReviewFailed extends ShopsState {
  final String error;
  SubmitReviewFailed(this.error);
}
