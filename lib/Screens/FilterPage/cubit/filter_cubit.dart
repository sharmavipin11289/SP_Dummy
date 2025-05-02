import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanaa/CommonFiles/common_api_response.dart';
import 'package:sanaa/CommonFiles/cubit/common_cubit.dart';
import 'package:sanaa/Screens/FilterPage/Model/category_tree_model.dart';

import '../../../ApiServices/api_service.dart';
import '../../../CommonFiles/common_variables.dart';
import '../../HomePage/Model/offers_model.dart';
import '../../HomePage/Model/shop_model.dart';
import 'filter_state.dart';

class FilterCubit extends Cubit<FilterState> {
  FilterCubit() : super(FilterInitial());

  final mainCategoryEndPoint = 'categories?type=CATEGORY_TREE';
  final shopEndPoint = 'vendors';
  final offerEndPoint = 'offers';

  Future<void> getCategoryTree() async {
    emit(CategoryTreeLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: mainCategoryEndPoint, method: 'get', fromJson: (json) => CategoryTreeModel.fromJson(json));
      if (response.data == null) {
        emit(CategoryTreeFailed());
      } else {
        print('data inside>>>>>>>>>>>>>>>> ');
        emit(
          CategoryTreeSuccess(categoryData: response.data ?? []),
        );
      }
    } catch (e) {
      emit(CategoryTreeFailed());
    }
  }


  Future<void> getVendors() async {
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



  Future<void> getOffers() async {
    emit(OffersLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: offerEndPoint, method: 'get', fromJson: (json) => OffersModel.fromJson(json));
      if (response.data == null) {
        emit(OffersFailed(response.message ?? somethingWentWrong));
      } else {
        print('data inside>>>>>>>>>>>>>>>> ');
        emit(OffersSuccess(response.data ?? []));
      }
    } catch (e) {
      emit(OffersFailed('$e'));
    }
  }

}
