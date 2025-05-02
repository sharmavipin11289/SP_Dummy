// Define the states for the login feature.
import 'package:sanaa/CommonFiles/Model/products_model.dart';
import 'package:sanaa/CommonFiles/common_api_response.dart';
import 'package:sanaa/Screens/Account/Model/currency_model.dart';

abstract class CommonState {}

class CommonInitial extends CommonState {}

//currency loading
class CommonLoading extends CommonState{}
class CommonSuccess extends CommonState {}
class InitiateCheckoutSuccess extends CommonState{}
class CommonFailed extends CommonState {
  String error;
  CommonFailed({required this.error});
}

class CheckoutSummarySuccess extends CommonState{
  OrderData? orderData;
  CheckoutSummarySuccess({required this.orderData});
}
