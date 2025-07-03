import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanaa/ApiServices/api_service.dart';
import 'package:sanaa/CommonFiles/Model/products_model.dart';
import 'package:sanaa/CommonFiles/common_api_response.dart';
import 'package:sanaa/Screens/HomePage/Model/advertisment_model.dart';
import 'package:sanaa/Screens/HomePage/Model/banner_model.dart';
import 'package:sanaa/Screens/HomePage/Model/offers_model.dart';
import 'package:sanaa/Screens/HomePage/Model/shop_model.dart';
import 'package:sanaa/Screens/HomePage/Model/testimonial_model.dart';
import '../../../CommonFiles/common_variables.dart';
import '../../../SharedPrefrence/shared_prefrence.dart';
import '../../Account/Model/user_detail_model.dart';
import '../Model/main_category_model.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final bannerEndPoint = 'banners';
  final mainCategoryEndPoint = 'categories?';
  final offerEndPoint = 'offers';
  final shopEndPoint = 'vendors';
  final popularProduct = 'products?view=popular';
  final recommendedProduct = 'products?view=recommended';
  final _userDetail = 'profile';
  final _testimonialEndPoint = 'testimonials';
  final _advertisment = 'advertisements?path=HOME';
  final _logout = 'auth/signout';



  logoutUser(Map<String,dynamic> param) async{
    emit(LogoutLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: _logout, method: 'post',body: param, fromJson: (json) => CommonResponse.fromJson(json));
        emit(LogoutSuccess());
    } catch (e) {
        emit(LogoutFailed('$e'));
    }
  }

  //banners
  Future<void> getBanners() async {
    emit(HomeBannerLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: bannerEndPoint, method: 'get', fromJson: (json) => BannerModel.fromJson(json));
      if (response.data == null) {
        emit(HomeBannerFailed(response.message ?? somethingWentWrong));
      } else {
        emit(HomeBannerSuccess(response.data ?? []));
      }
    } catch (e) {
      emit(HomeBannerFailed('$e'));
    }
  }

  // main categories
  Future<void> getMainCategories({int page = 1}) async {
    emit(MainCategoryLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: mainCategoryEndPoint + 'page=$page' + '&type=MAIN_CATEGORIES', method: 'get', fromJson: (json) => MainCategory.fromJson(json));
      if (response.data == null) {
        emit(MainCategoryFailed(response.message ?? somethingWentWrong));
      } else {
        print('data inside>>>>>>>>>>>>>>>> ');
        emit(MainCategorySuccess(response.data ?? [], response.meta));
      }
    } catch (e) {
      emit(MainCategoryFailed('$e'));
    }
  }

  // offers
  Future<void> getOffers({int page = 1}) async {
    emit(OffersLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: offerEndPoint + '?page=$page', method: 'get', fromJson: (json) => OffersModel.fromJson(json));
      if (response.data == null) {
        emit(OffersFailed(response.message ?? somethingWentWrong));
      } else {
        print('data inside>>>>>>>>>>>>>>>> ');
        emit(OffersSuccess(response.data ?? [], response.meta));
      }
    } catch (e) {
      emit(OffersFailed('$e'));
    }
  }

  //shops
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

  //testimonial
  Future<void> getTestimonials({int page = 1}) async {
    emit(TestimonialsLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: _testimonialEndPoint + '?page=$page', method: 'get', fromJson: (json) => TestimonialModal.fromJson(json));
      if (response.data == null) {
        emit(TestimonialsFailed(response.message ?? somethingWentWrong));
      } else {
        print('data inside>>>>>>>>>>>>>>>> ');
        emit(TestimonialsSuccess(response.data ?? [], response.meta));
      }
    } catch (e) {
      emit(TestimonialsFailed('$e'));
    }
  }

  //get popular products
  Future<void> getPopularProducts() async {
    emit(PopularProductLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: popularProduct, method: 'get', fromJson: (json) => ProductsModel.fromJson(json));
      if (response.data == null) {
        emit(PopularProductFailed(response.message ?? somethingWentWrong));
      } else {
        print('data inside>>>>>>>>>>>>>>>> ');
        emit(PopularProductSuccess(response.data ?? []));
      }
    } catch (e) {
      print(popularProduct);
      emit(PopularProductFailed('$e'));
    }
  }

  //recommended products
  Future<void> getRecommendedProducts() async {
    emit(RecommendedLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: recommendedProduct, method: 'get', fromJson: (json) => ProductsModel.fromJson(json));
      print('data inside>>>>>>>>>>>>>>>> ${response.data}');
      emit(RecommendedProductSuccess(response.data ?? []));

    } catch (e) {
      emit(RecommendedProductFailed('$e'));
    }
  }


  //advertisment
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


  Future<void> getUserDetails() async{
    try {
      final response = await ApiService().request(endpoint: _userDetail, method: 'get', fromJson: (json) => UserDetailModel.fromJson(json));
      print(response.message);
      emit(ProfileSuccess(response.data));
    } catch (e) {
      emit(ProfileFailed(error: '$e'));
    }
  }

  Future<UserDetail?> getSavedUserDetail() async {
    // Retrieve and deserialize the object
    return SharedPreferencesHelper.getCustomObject(
      'user_detail',
          (json) => UserDetail.fromJson(json),
    );
  }

  Future<void> saveUserDetail(UserDetail userDetail) async {
    // Convert the object to JSON and save it as a string
    await SharedPreferencesHelper.saveCustomObject(
      'user_detail',
      userDetail.toJson(),
    );
    print("Saved::::");
  }
}
