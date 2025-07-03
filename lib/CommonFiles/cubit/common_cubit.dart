import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanaa/ApiServices/api_service.dart';
import 'package:sanaa/CommonFiles/Model/payment_method_model.dart';
import 'package:sanaa/CommonFiles/Model/products_model.dart';
import 'package:sanaa/CommonFiles/common_api_response.dart';
import 'package:sanaa/CommonFiles/common_function.dart';
import 'package:sanaa/CommonFiles/common_variables.dart';
import 'package:sanaa/CommonFiles/cubit/common_state.dart';
import 'package:sanaa/Screens/Account/Model/currency_model.dart';
import 'package:sanaa/Screens/WishlistPage/cubit/wish_list_state.dart';


class CommonCubit extends Cubit<CommonState> {
  CommonCubit() : super(CommonInitial());

  final _moveProductInWishList = 'wishlist';
  final _moveProductInCart = 'cart';
  final _initiateCheckout = 'checkout/initialize';
  final _checkoutSummary = 'checkout/summary?';

  addProductToWishList(Map<String,dynamic> param) async{
    emit(CommonLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: _moveProductInWishList, body: param,method: 'post', fromJson: (json) => CommonResponse.fromJson(json));
      print(response.message);
      emit(CommonSuccess());
    } catch (e) {
      emit(CommonFailed(error: '$e'));
    }
  }

  addProductToCart(Map<String,dynamic> param) async{
    print(param);
    emit(CommonLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: _moveProductInCart, body: param,method: 'post', fromJson: (json) => CommonResponse.fromJson(json));
      print(response.message);
      showToast( response.message ?? '');
      emit(CommonSuccess());
    } catch (e) {
      showToast(e.toString());
      emit(CommonFailed(error: '$e'));
    }
  }

  checkoutInitiate() async {
    emit(CommonLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: _initiateCheckout,method: 'get', fromJson: (json) => paymentMethodModel.fromJson(json));
      print(response.message);
      paymentData = response.data;
    } catch (e) {
      showToast(e.toString());
      emit(CommonFailed(error: '$e'));
    }
  }

  Future<bool> checkoutSummary(String coupon, String currency) async {
    emit(CommonLoading()); // Emit loading state
    try {
      String queryString = '';
      if(currency.isNotEmpty){
        queryString = 'currency=$currency';
      }
      if(coupon.isNotEmpty) {
        queryString += '&coupon=$coupon';
      }

      final response = await ApiService().request(endpoint: _checkoutSummary + queryString,method: 'get', fromJson: (json) => OrderSummaryModel.fromJson(json));
      print(response.message);
      print(response.data);
      emit(CheckoutSummarySuccess(orderData: response.data));
      return true;
    } catch (e) {
      showToast(e.toString());
      //emit(CommonFailed(error: '$e'));
      return false;
    }
  }

}