import '../../HomePage/Model/offers_model.dart';
import '../../HomePage/Model/shop_model.dart';
import '../Model/category_tree_model.dart';

abstract class FilterState {}

class FilterInitial extends FilterState {}

class CategoryTreeLoading extends FilterState{}

class CategoryTreeFailed extends FilterState{}

class CategoryTreeSuccess extends FilterState{
  List<CategooryTreeData> categoryData;
  CategoryTreeSuccess({required this.categoryData});
}



//Offers
class OffersLoading extends FilterState {}
class OffersSuccess extends FilterState {
  List<OfferData> offerData;
  OffersSuccess(this.offerData);
}
class OffersFailed extends FilterState {
  final String error;
  OffersFailed(this.error);
}
//--

//shops
class ShopsLoading extends FilterState {}
class ShopsSuccess extends FilterState {
  List<ShopData> shopsData;
  ShopsSuccess(this.shopsData);
}
class ShopsFailed extends FilterState {
  final String error;
  ShopsFailed(this.error);
}