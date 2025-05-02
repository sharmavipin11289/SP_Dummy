// Define the states for the login feature.
import 'package:sanaa/CommonFiles/Model/products_model.dart';
import 'package:sanaa/Screens/Account/Model/currency_model.dart';

abstract class WishListState {}

class WishListInitial extends WishListState {}

//currency loading
class WishListLoading extends WishListState{}
class WishListSuccess extends WishListState {
  List<ProductData> products;
  WishListSuccess(this.products);
}
class WishListFailed extends WishListState {
  String error;
  WishListFailed({required this.error});
}



class DeleteWishListLoading extends WishListState{}
class DeleteWishListSuccess extends WishListState {}
class DeleteWishListFailed extends WishListState {
  String error;
  DeleteWishListFailed({required this.error});
}
