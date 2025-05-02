
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanaa/CommonFiles/common_function.dart';
import 'package:sanaa/Screens/ExcitingOfferPage/cubit/product_state.dart';

import '../../../ApiServices/api_service.dart';
import '../../../CommonFiles/Model/products_model.dart';
import '../../../CommonFiles/common_variables.dart';

class ProductCubit extends Cubit<ProductsState> {
  ProductCubit() : super(ProductInitial());

  final _endPoint = 'products';



  Future<void> getProducts(Map<String, dynamic>? param) async {
    emit(ProductsLoading()); // Emit loading state
    try {
      String queryString = '';
      if(param != null) {
        queryString = mapToQueryString(param);
      }
      final response = await ApiService().request(endpoint: _endPoint + queryString, method: 'get', fromJson: (json) => ProductsModel.fromJson(json));
      if (response.data == null) {
        emit(ProductsFailed(response.message ?? somethingWentWrong));
      } else {
        print('data inside>>>>>>>>>>>>>>>> ');
        emit(ProductsSuccess(response.data ?? []));
      }
    } catch (e) {
      emit(ProductsFailed('$e'));
    }
  }

}