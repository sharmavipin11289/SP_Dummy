// Define the states for the login feature.
import 'package:sanaa/CommonFiles/Model/products_model.dart';
import 'package:sanaa/CommonFiles/common_api_response.dart';
import 'package:sanaa/Screens/Account/Model/currency_model.dart';
import 'package:sanaa/Screens/MyCartPage/Model/cart_model.dart';
import 'package:sanaa/Screens/MyCartPage/Model/cart_summary_model.dart';
import 'package:sanaa/Screens/MyCartPage/Model/coupon_model.dart';

abstract class CartState {}

class CartInitial extends CartState {}



//cart loading
class CartLoading extends CartState{}
class CartGetSuccess extends CartState {
  List<CartData> products;
  CartGetSuccess({required this.products});
}
class CartGetFailed extends CartState {
  String error;
  CartGetFailed({required this.error});
}


//---------
class DeleteCartLoading extends CartState{}
class DeleteCartSuccess extends CartState {}
class DeleteCartFailed extends CartState {
  String error;
  DeleteCartFailed({required this.error});
}


class CartSummarySuccess extends CartState {
  CartSummaryData? summaryData;
  CartSummarySuccess(this.summaryData);
}

class CartSummaryFailed extends CartState {
  String error;
  CartSummaryFailed({required this.error});
}


class CouponSuccess extends CartState {
  List<CouponData> coupons;
  CouponSuccess(this.coupons);
}

class CouponFailed extends CartState {
  String error;
  CouponFailed({required this.error});
}



