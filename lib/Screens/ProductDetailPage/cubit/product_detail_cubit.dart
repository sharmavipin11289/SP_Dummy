import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanaa/CommonFiles/common_api_response.dart';
import 'package:sanaa/Screens/ProductDetailPage/cubit/product_detail_state.dart';
import 'package:sanaa/Screens/ProductDetailPage/model/product_detail_model.dart';

import '../../../ApiServices/api_service.dart';
import '../../../CommonFiles/Model/products_model.dart';
import '../../../CommonFiles/common_function.dart';
import '../../../CommonFiles/common_variables.dart';
import '../../PaymentPage/model/checkout_summary_model.dart';
import '../model/product_review_model.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit() : super(ProductDetailInitial());

 final _productDetail = 'products/' ;
 final _productReview = 'product-reviews';
 final _relatedProdouct = 'products';
  final _endPoint = 'checkout/summary';



  Future<void> getProductDetail(String productID,Map<String, dynamic> param) async {
    emit(ProductDetailLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: convertToUrlParams(_productDetail + productID, param), method: 'get', fromJson: (json) => ProductDetailModel.fromJson(json));
      print("REEEEEE");
      print(response);
      emit(ProductDetailSuccess(response.data));
    } catch (e) {
      emit(ProductDetailFailed('$e'));
    }
  }

  Future<void> getRelatedProducts(Map<String,dynamic> param) async {
    emit(RelatedProductLoading());
    try {
      final response = await ApiService().request(endpoint: convertToUrlParams(_relatedProdouct, param), method: 'get', fromJson: (json) => ProductsModel.fromJson(json));
      if (response.data == null) {
        emit(RelatedProductFailed(response.message ?? somethingWentWrong));
      } else {
        print('data inside>>>>>>>>>>>>>>>> ');
        emit(RelatedProductSuccess(response.data ?? []));
      }
    } catch (e) {
      emit(RelatedProductFailed('$e'));
    }
  }

  Future<void> getProductReview(String productID, {int page = 1}) async {
    emit(ProductDetailLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: _productReview + "?product_id=" + productID + '&page=$page', method: 'get', fromJson: (json) => ProductReviewModel.fromJson(json));
      print("REEEEEE");
      print(response);
      emit(ProductReviewSuccess(response.data ?? [], response.meta));
    } catch (e) {
      emit(ProductDetailFailed('$e'));
    }
  }

  Future<void> submitProductReview(Map<String,dynamic> param) async {
    emit(SubmitReviewLoading());
    try {
      final response = await ApiService().request(endpoint: _productReview, method: 'post', body: param, fromJson: (json) => CommonResponse.fromJson(json));
        emit(SubmitReviewSuccess());
     } catch (e) {
      emit(SubmitReviewLoading());
    }
  }

  Future<void> getOrderSummary(Map<String, dynamic> param) async {
    emit(OrderSummeryLoading());
    try {
      final response = await ApiService().request(endpoint: convertToUrlParams(_endPoint, param), method: 'get', fromJson: (json) => CheckoutSummaryModel.fromJson(json));
      print(response.message);
      if(response.data != null) {
        emit(OrderSummeryLoaded(summaryData: response.data));
      }
      else {
        emit(OrderSummeryFailed(error: '${response.message}'));
      }
    } catch (e) {
      emit(OrderSummeryFailed(error: '${e.toString()}'));
    }
  }
}