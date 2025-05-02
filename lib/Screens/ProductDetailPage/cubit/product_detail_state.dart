import 'package:sanaa/Screens/ProductDetailPage/model/product_detail_model.dart';
import 'package:sanaa/Screens/ProductDetailPage/model/product_review_model.dart';

import '../../../CommonFiles/Model/products_model.dart';

abstract class ProductDetailState {}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailSuccess extends ProductDetailState {
  ProductDetail? productDetail;
  ProductDetailSuccess(this.productDetail);
}

class ProductReviewSuccess extends ProductDetailState {
  List<ProductReview> productReviews;
  ProductReviewSuccess(this.productReviews);
}

class ProductDetailFailed extends ProductDetailState {
  String error;
  ProductDetailFailed(this.error);
}


class RelatedProductLoading extends ProductDetailState {}
class RelatedProductSuccess extends ProductDetailState {
  List<ProductData> relatedProducts;
  RelatedProductSuccess(this.relatedProducts);
}
class RelatedProductFailed extends ProductDetailState {
  final String error;
  RelatedProductFailed(this.error);
}

class SubmitReviewLoading extends ProductDetailState {}

class SubmitReviewSuccess extends ProductDetailState {}
class SubmitReviewFailed extends ProductDetailState {
  final String error;
  SubmitReviewFailed(this.error);
}
