import 'package:sanaa/CommonFiles/Model/products_model.dart';

import '../../../CommonFiles/Model/meta_model.dart';
import '../../HomePage/Model/advertisment_model.dart';

abstract class ProductsState {}

class ProductInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsFailed extends ProductsState {
  String error;
  ProductsFailed(this.error);
}

class ProductsSuccess extends ProductsState {
  List<ProductData> products;
  Meta? meta;
  ProductsSuccess(this.products, this.meta);
}


class AdvertismentLoading extends ProductsState {}
class AdvertismentSuccess extends ProductsState {
  List<AdvertismentData> advertismentData;
  AdvertismentSuccess(this.advertismentData);
}
class AdvertismentFailed extends ProductsState {
  final String error;
  AdvertismentFailed(this.error);
}