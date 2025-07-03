// Define the states for the login feature.
import 'package:sanaa/CommonFiles/common_api_response.dart';
import 'package:sanaa/Screens/Account/Model/currency_model.dart';
import 'package:sanaa/Screens/Account/Model/user_detail_model.dart';
import 'package:sanaa/Screens/OrderDetails/Model/order_detail_model.dart';
import 'package:sanaa/Screens/OrderDetails/Model/place_order_model.dart';

import '../../../CommonFiles/Model/meta_model.dart';
import '../Model/order_model.dart';

abstract class OrderState {}

class OrdersInitial extends OrderState {}



//currency loading
class Ordersloading extends OrderState{}
class OrdersSuccess extends OrderState {
  List<Order> orders;
  Meta? meta;
  OrdersSuccess(this.orders, this.meta);
}

class OrderDetailSuccess extends OrderState {
  OrderDetailData? orderData;
  OrderDetailSuccess(this.orderData);
}

class OrdersFailed extends OrderState {
  String error;
  OrdersFailed({required this.error});
}


class InvoiceLoading extends OrderState{}

class InvoiceSuccess extends OrderState {
  OrderDetailData? orderData;
  InvoiceSuccess(this.orderData);
}

class InvoiceFailed extends OrderState {
  String error;
  InvoiceFailed({required this.error});
}


//place order (PO)
class POLoading extends OrderState{}

class POSuccess extends OrderState {
  PlaceOrderData? orderData;
  POSuccess({required this.orderData});
}

class POFailed extends OrderState {
  String error;
  POFailed({required this.error});
}



