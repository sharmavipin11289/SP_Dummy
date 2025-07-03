import 'package:sanaa/Screens/ProductDetailPage/model/product_detail_model.dart';
import 'package:sanaa/Screens/ProductDetailPage/model/product_review_model.dart';

import '../../../CommonFiles/Model/meta_model.dart';
import '../../../CommonFiles/Model/products_model.dart';
import '../../PaymentPage/model/checkout_summary_model.dart';

abstract class ProductDetailState {}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailSuccess extends ProductDetailState {
  ProductDetail? productDetail;
  ProductDetailSuccess(this.productDetail);
}

class ProductReviewSuccess extends ProductDetailState {
  List<ProductReview> productReviews;
  Meta? meta;
  ProductReviewSuccess(this.productReviews, this.meta);
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


class OrderSummeryLoading extends ProductDetailState {}

class OrderSummeryLoaded extends ProductDetailState {
  CheckoutSummaryData? summaryData;
  OrderSummeryLoaded({this.summaryData});
}

class OrderSummeryFailed extends ProductDetailState {
  String error;
  OrderSummeryFailed({required this.error});
}

