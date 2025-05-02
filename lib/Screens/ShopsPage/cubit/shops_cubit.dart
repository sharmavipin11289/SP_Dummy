import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanaa/CommonFiles/Model/products_model.dart';
import 'package:sanaa/Screens/ShopsPage/cubit/shops_state.dart';
import 'package:sanaa/Screens/ShopsPage/model/shop_detail_model.dart';

import '../../../ApiServices/api_service.dart';
import '../../../CommonFiles/common_variables.dart';
import '../../HomePage/Model/shop_model.dart';

class ShopsCubit extends Cubit<ShopsState> {
  ShopsCubit() : super(ShopInitial());

  final shopEndPoint = 'vendors';
  final _shopProducts = 'products?vendor_ids[0]=';

  Future<void> getShops() async {
    emit(ShopsLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: shopEndPoint, method: 'get', fromJson: (json) => ShopModel.fromJson(json));
      if (response.data == null) {
        emit(ShopsFailed(response.message ?? somethingWentWrong));
      } else {
        print('data inside>>>>>>>>>>>>>>>> ');
        emit(ShopsSuccess(response.data ?? []));
      }
    } catch (e) {
      emit(ShopsFailed('$e'));
    }
  }

  Future<void> getShopDetail(String shopID) async {
    emit(ShopsLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: shopEndPoint + '/$shopID', method: 'get', fromJson: (json) => ShopDetailModel.fromJson(json));
        print('data inside>>>>>>>>>>>>>>>> ');
        emit(ShopDetailSuccess(response.data));
    } catch (e) {
      emit(ShopsFailed('$e'));
    }
  }


  Future<void> getShopProducts(String shopID) async {
    emit(ShopProductLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: _shopProducts + shopID, method: 'get', fromJson: (json) => ProductsModel.fromJson(json));
      if (response.data == null) {
        emit(ShopProductFailed(response.message ?? somethingWentWrong));
      } else {
        print('data inside>>>>>>>>>>>>>>>> ');
        emit(ShopProductSuccess(response.data ?? []));
      }
    } catch (e) {
      emit(ShopProductFailed('$e'));
    }
  }

}