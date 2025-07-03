import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanaa/ApiServices/api_service.dart';
import 'package:sanaa/CommonFiles/common_api_response.dart';
import 'package:sanaa/Screens/Account/Model/currency_model.dart';
import 'package:sanaa/Screens/Account/Model/user_detail_model.dart';
import 'package:sanaa/Screens/OrderDetails/Model/order_detail_model.dart';
import 'package:sanaa/Screens/OrderDetails/Model/order_model.dart';
import 'package:sanaa/Screens/OrderDetails/Model/place_order_model.dart';
import 'package:sanaa/Screens/OrderDetails/cubit/order_state.dart';
import '../../../SharedPrefrence/shared_prefrence.dart';



class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrdersInitial());

  final _orders = 'orders';
  final _orders_ = 'orders/';
  final _placeOrderEndPoint = 'checkout/order';


  //getCurrencies
  Future<void> getOrders({int page = 1}) async {
    emit(Ordersloading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: _orders + '?page=$page', method: 'get', fromJson: (json) => OrdersModel.fromJson(json));
      print(response.message);
      emit(OrdersSuccess(response.data ?? [],response.meta));
    } catch (e) {
      emit(OrdersFailed(error: '$e'));
    }
  }


  Future<void> getOrderDetails(String orderId) async {
    emit(Ordersloading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: _orders_ + orderId, method: 'get', fromJson: (json) => OrderDetailModel.fromJson(json));
      print(response.message);
      emit(OrderDetailSuccess(response.data));
    } catch (e) {
      emit(OrdersFailed(error: '$e'));
    }
  }


  Future<void> getInvoiceFor(String orderId, String orderItemId,Map<String,dynamic> param) async {
    emit(InvoiceLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: _orders + '$orderId/order-items/$orderItemId/invoice', method: 'get',body: param, fromJson: (json) => CommonResponse.fromJson(json));
      print(response.message);
      emit(InvoiceSuccess(response.data));
    } catch (e) {
      emit(InvoiceFailed(error: '$e'));
    }
  }

  placeOrder(Map<String,dynamic> param) async {
    emit(POLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: _placeOrderEndPoint, method: 'post',body: param, fromJson: (json) => PlaceOrderModel.fromJson(json));
      print(response.message);
      emit(POSuccess(orderData: response.data));
    } catch (e) {
      emit(POFailed(error: '$e'));
    }
  }
}