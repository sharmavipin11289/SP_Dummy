import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanaa/ApiServices/api_service.dart';
import 'package:sanaa/CommonFiles/Model/products_model.dart';
import 'package:sanaa/Screens/MyCartPage/Model/cart_model.dart';
import 'package:sanaa/Screens/MyCartPage/Model/cart_summary_model.dart';
import 'package:sanaa/Screens/MyCartPage/Model/coupon_model.dart';


import '../../../CommonFiles/common_api_response.dart';
import 'cart_state.dart';



class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  final _cartEndPoint = 'cart?limit=all';
  final _deleteCartEndPoint = 'cart/';
  final _cartSummary = 'cart/summary?';
  final _coupons = 'coupons?limit=all';

  //get cart
  Future<void> getCartProducts() async {
    print("inside");
    emit(CartLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: _cartEndPoint, method: 'get', fromJson: (json) => CartModel.fromJson(json));
      print(response.message);
      emit(CartGetSuccess(products: response.data ?? []));
    } catch (e) {
      emit(CartGetFailed(error: '$e'));
    }
  }

  Future<void> updateCart(String cartId, Map<String,dynamic> param) async{
    emit(CartLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: _deleteCartEndPoint + '$cartId', method: 'patch',body: param, fromJson: (json) => CommonResponse.fromJson(json));
      print(response.message);
      getCartProducts();
    } catch (e) {
      emit(DeleteCartFailed(error: '$e'));
    }
  }

  Future<void> deleteCart(String cartId) async{
    emit(CartLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: _deleteCartEndPoint + '$cartId', method: 'delete', fromJson: (json) => CommonResponse.fromJson(json));
      print(response.message);
      getCartProducts();
    } catch (e) {
      emit(DeleteCartFailed(error: '$e'));
    }
  }

  Future<void> getCartSummary(String couponCode, String currency) async{
    emit(CartLoading()); // Emit loading state
    try {
      print("CCCCC:: $couponCode");
      String _queryString;
      if(couponCode.isNotEmpty && currency.isNotEmpty) {
        _queryString = 'coupon=$couponCode&currency=$currency';
      }else if (couponCode.isNotEmpty) {
        _queryString = 'coupon=$couponCode';
      } else {
        _queryString = 'currency=$currency';
      }

      final response = await ApiService().request(endpoint: _cartSummary + _queryString, method: 'get', fromJson: (json) => CartSummaryModel.fromJson(json));
      print(response.message);
      print("enit::::::");
      emit(CartSummarySuccess(response.data));

    } catch (e) {
      print(e);
      emit(CartSummaryFailed(error: '$e'));
    }
  }

  Future<void> getCoupons() async{
    emit(CartLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: _coupons, method: 'get', fromJson: (json) => CouponModel.fromJson(json));
      print(response.message);
      print("enit::::::");
      emit(CouponSuccess(response.data ?? []));
    } catch (e) {
      print(e);
      emit(CouponFailed(error: '$e'));
    }
  }



}