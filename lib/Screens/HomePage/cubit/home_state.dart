// Define the states for the login feature.
import 'package:sanaa/CommonFiles/Model/products_model.dart';
import 'package:sanaa/Screens/HomePage/Model/banner_model.dart';
import 'package:sanaa/Screens/HomePage/Model/main_category_model.dart';
import 'package:sanaa/Screens/HomePage/Model/offers_model.dart';
import 'package:sanaa/Screens/HomePage/Model/shop_model.dart';
import 'package:sanaa/Screens/HomePage/Model/testimonial_model.dart';

import '../../Account/Model/user_detail_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

//banner
class HomeBannerLoading extends HomeState {}
class HomeBannerSuccess extends HomeState {
  List<BannerData> bannerData;
  HomeBannerSuccess(this.bannerData);
}
class HomeBannerFailed extends HomeState {
  final String error;
  HomeBannerFailed(this.error);
}
//--

//category
class MainCategoryLoading extends HomeState {}
class MainCategorySuccess extends HomeState {
  List<MainCategoryData> categoryData;
  MainCategorySuccess(this.categoryData);
}
class MainCategoryFailed extends HomeState {
  final String error;
  MainCategoryFailed(this.error);
}
//--


//Offers
class OffersLoading extends HomeState {}
class OffersSuccess extends HomeState {
  List<OfferData> offerData;
  OffersSuccess(this.offerData);
}
class OffersFailed extends HomeState {
  final String error;
  OffersFailed(this.error);
}
//--



//shops
class ShopsLoading extends HomeState {}
class ShopsSuccess extends HomeState {
  List<ShopData> shopsData;
  ShopsSuccess(this.shopsData);
}
class ShopsFailed extends HomeState {
  final String error;
  ShopsFailed(this.error);
}
//--


//popularProducts
class PopularProductLoading extends HomeState {}
class PopularProductSuccess extends HomeState {
  List<ProductData> popularProducts;
  PopularProductSuccess(this.popularProducts);
}
class PopularProductFailed extends HomeState {
  final String error;
  PopularProductFailed(this.error);
}
//--



//recommendedProducts
class RecommendedLoading extends HomeState {}
class RecommendedProductSuccess extends HomeState {
  List<ProductData> recommendedProducts;
  RecommendedProductSuccess(this.recommendedProducts);
}
class RecommendedProductFailed extends HomeState {
  final String error;
  RecommendedProductFailed(this.error);
}
//--



//Testimonials
class TestimonialsLoading extends HomeState {}
class TestimonialsSuccess extends HomeState {
  List<Testimonial> testimonials;
  TestimonialsSuccess(this.testimonials);
}
class TestimonialsFailed extends HomeState {
  final String error;
  TestimonialsFailed(this.error);
}
//--


class ProfileSuccess extends HomeState {
  UserDetail? userDetail;
  ProfileSuccess(this.userDetail);
}
class ProfileFailed extends HomeState {
  String error;
  ProfileFailed({required this.error});
}