// Define the states for the login feature.
import 'package:sanaa/CommonFiles/Model/products_model.dart';
import 'package:sanaa/CommonFiles/common_api_response.dart';
import 'package:sanaa/Screens/Account/Model/currency_model.dart';
import 'package:sanaa/Screens/MyCartPage/Model/cart_model.dart';
import 'package:sanaa/Screens/MyCartPage/Model/cart_summary_model.dart';
import 'package:sanaa/Screens/MyCartPage/Model/coupon_model.dart';
import 'package:sanaa/Screens/PaymentPage/model/checkout_summary_model.dart';

abstract class PaymentPageState {}

class PaymentPageInitial extends PaymentPageState {}

class OrderSummeryLoading extends PaymentPageState {}

class OrderSummeryLoaded extends PaymentPageState {
  CheckoutSummaryData? summaryData;
  OrderSummeryLoaded({this.summaryData});
}

class OrderSummeryFailed extends PaymentPageState {
  String error;
  OrderSummeryFailed({required this.error});
}


class ConfirmPaymentLoading extends PaymentPageState {}

class ConfirmPaymentSuccess extends PaymentPageState {

  ConfirmPaymentSuccess();
}

class ConfirmPaymentFailed extends PaymentPageState {
  String error;
  ConfirmPaymentFailed({required this.error});
}




