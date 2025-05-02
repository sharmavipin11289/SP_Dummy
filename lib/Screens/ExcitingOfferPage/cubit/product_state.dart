import 'package:sanaa/CommonFiles/Model/products_model.dart';

abstract class ProductsState {}

class ProductInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsFailed extends ProductsState {
  String error;
  ProductsFailed(this.error);
}

class ProductsSuccess extends ProductsState {
  List<ProductData> products;
  ProductsSuccess(this.products);
}