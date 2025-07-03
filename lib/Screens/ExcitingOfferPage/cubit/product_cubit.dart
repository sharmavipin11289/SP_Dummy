
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanaa/CommonFiles/common_function.dart';
import 'package:sanaa/Screens/ExcitingOfferPage/cubit/product_state.dart';

import '../../../ApiServices/api_service.dart';
import '../../../CommonFiles/Model/products_model.dart';
import '../../../CommonFiles/common_variables.dart';
import '../../HomePage/Model/advertisment_model.dart';

class ProductCubit extends Cubit<ProductsState> {
  ProductCubit() : super(ProductInitial());

  final _endPoint = 'products';
  final _advertisment = 'advertisements?path=PRODUCTS';



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
        emit(ProductsSuccess(response.data ?? [],response.meta));
      }
    } catch (e) {
      emit(ProductsFailed('$e'));
    }
  }

  Future<void> getAdvertismentData() async {
    emit(AdvertismentLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: _advertisment, method: 'get', fromJson: (json) => AdvertismentModel.fromJson(json));
      print('data inside>>>>>>>>>>>>>>>> ${response.data}');
      emit(AdvertismentSuccess(response.data ?? []));

    } catch (e) {
      emit(AdvertismentFailed('$e'));
    }
  }

}