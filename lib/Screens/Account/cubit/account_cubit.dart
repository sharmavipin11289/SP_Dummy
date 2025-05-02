import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanaa/ApiServices/api_service.dart';
import 'package:sanaa/CommonFiles/common_api_response.dart';
import 'package:sanaa/Screens/Account/Model/currency_model.dart';
import 'package:sanaa/Screens/Account/Model/user_detail_model.dart';
import '../../../SharedPrefrence/shared_prefrence.dart';
import 'account_state.dart';


class AccountCubit extends Cubit<AccountState> {
  AccountCubit() : super(AccountInitial());

  final _currenciesEndPoint = 'currencies';
  final _userDetail = 'profile';

  //getCurrencies
  Future<void> getCurrencies() async {
    emit(CurrencyLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: _currenciesEndPoint, method: 'get', fromJson: (json) => CurrencyModel.fromJson(json));
      print(response.message);
      emit(CurrencyGetSuccess(currencies: response.data ?? []));
    } catch (e) {
      emit(CurrencyGetFailed(error: '$e'));
    }
  }

  Future<void> getUserDetails() async{
    emit(ProfileLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: _userDetail, method: 'get', fromJson: (json) => UserDetailModel.fromJson(json));
      print(response.message);
      emit(ProfileSuccess(response.data));
    } catch (e) {
      emit(ProfileFailed(error: '$e'));
    }
  }

  Future<void> saveUserDetail(UserDetail userDetail) async {
    // Convert the object to JSON and save it as a string
    await SharedPreferencesHelper.saveCustomObject(
      'user_detail',
      userDetail.toJson(),
    );
    print("Saved::::");
  }

  Future<UserDetail?> getSavedUserDetail() async {
    // Retrieve and deserialize the object
    return SharedPreferencesHelper.getCustomObject(
      'user_detail',
          (json) => UserDetail.fromJson(json),
    );
  }

}