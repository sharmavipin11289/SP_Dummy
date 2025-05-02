import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanaa/ApiServices/api_service.dart';
import 'package:sanaa/CommonFiles/Model/products_model.dart';
import 'package:sanaa/CommonFiles/common_function.dart';
import 'package:sanaa/Screens/MyCartPage/Model/cart_model.dart';
import 'package:sanaa/Screens/MyCartPage/Model/cart_summary_model.dart';
import 'package:sanaa/Screens/MyCartPage/Model/coupon_model.dart';
import 'package:sanaa/Screens/PaymentPage/cubit/payment_page_state.dart';

import '../../../CommonFiles/common_api_response.dart';
import '../model/checkout_summary_model.dart';

class PaymentPageCubit extends Cubit<PaymentPageState> {
  PaymentPageCubit() : super(PaymentPageInitial());

  final _endPoint = 'checkout/summary';
  final _confirmPayment = 'checkout/confirm-payment';
  //get cart
  Future<void> getOrderSummary(Map<String, dynamic> param) async {
    emit(OrderSummeryLoading());
    try {
      final response = await ApiService().request(endpoint: convertToUrlParams(_endPoint, param), method: 'get', fromJson: (json) => CheckoutSummaryModel.fromJson(json));
      print(response.message);
      emit(OrderSummeryLoaded(summaryData: response.data));
    } catch (e) {
      emit(OrderSummeryFailed(error: '${e.toString()}'));
    }
  }

  Future<void> confirmOrder(Map<String, dynamic> param) async {
    emit(ConfirmPaymentLoading());
    try {
      final response = await ApiService().request(endpoint: _confirmPayment, method: 'post', body: param, fromJson: (json) => CommonResponse.fromJson(json));
      print(response.message);
      emit(ConfirmPaymentSuccess());
    } catch (e) {
      emit(ConfirmPaymentFailed(error: e.toString()));
    }
  }
}
