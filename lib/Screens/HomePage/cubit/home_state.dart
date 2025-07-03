// Define the states for the login feature.
import 'package:sanaa/CommonFiles/Model/products_model.dart';
import 'package:sanaa/Screens/HomePage/Model/banner_model.dart';
import 'package:sanaa/Screens/HomePage/Model/main_category_model.dart';
import 'package:sanaa/Screens/HomePage/Model/offers_model.dart';
import 'package:sanaa/Screens/HomePage/Model/shop_model.dart';
import 'package:sanaa/Screens/HomePage/Model/testimonial_model.dart';

import '../../../CommonFiles/Model/meta_model.dart';
import '../../Account/Model/user_detail_model.dart';
import '../Model/advertisment_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

//logout
class LogoutLoading extends HomeState {}
class LogoutSuccess extends HomeState {}
class LogoutFailed extends HomeState {
  final String error;
  LogoutFailed(this.error);
}


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
  Meta? meta;
  MainCategorySuccess(this.categoryData, this.meta);
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
  Meta? meta;
  OffersSuccess(this.offerData, this.meta);
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



class AdvertismentLoading extends HomeState {}
class AdvertismentSuccess extends HomeState {
  List<AdvertismentData> advertismentData;
  AdvertismentSuccess(this.advertismentData);
}
class AdvertismentFailed extends HomeState {
  final String error;
  AdvertismentFailed(this.error);
}


//Testimonials
class TestimonialsLoading extends HomeState {}
class TestimonialsSuccess extends HomeState {
  List<Testimonial> testimonials;
  Meta? meta;
  TestimonialsSuccess(this.testimonials, this.meta);
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