import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanaa/ApiServices/api_service.dart';
import 'package:sanaa/CommonFiles/Model/products_model.dart';
import 'package:sanaa/CommonFiles/common_api_response.dart';
import 'package:sanaa/Screens/Account/Model/currency_model.dart';
import 'package:sanaa/Screens/WishlistPage/cubit/wish_list_state.dart';


class WishListCubit extends Cubit<WishListState> {
  WishListCubit() : super(WishListInitial());

  final _wishListEndPoint = 'wishlist';


  //getCurrencies
  Future<void> getWishListProduct() async {
    emit(WishListLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: _wishListEndPoint, method: 'get', fromJson: (json) => ProductsModel.fromJson(json,sourceType: 'wishlist'));
      print(response.message);
      emit(WishListSuccess(response.data ?? []));
    } catch (e) {
      emit(WishListFailed(error: '$e'));
    }
  }

  deleteProductFromWishList(Map<String,dynamic> param) async{
    emit(DeleteWishListLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: _wishListEndPoint,body: param, method: 'patch', fromJson: (json) => CommonResponse.fromJson(json));
      print(response.message);
      emit(DeleteWishListSuccess());
    } catch (e) {
      emit(DeleteWishListFailed(error: '$e'));
    }
  }


  addProductToWishList(Map<String,dynamic> param) async{
    //emit(CommonLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: _wishListEndPoint, body: param,method: 'post', fromJson: (json) => CommonResponse.fromJson(json));
      print(response.message);
     // emit(CommonSuccess());
    } catch (e) {
     // emit(CommonFailed(error: '$e'));
    }
  }


}