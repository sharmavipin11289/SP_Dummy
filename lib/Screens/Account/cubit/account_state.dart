// Define the states for the login feature.
import 'package:sanaa/CommonFiles/common_api_response.dart';
import 'package:sanaa/Screens/Account/Model/currency_model.dart';
import 'package:sanaa/Screens/Account/Model/user_detail_model.dart';

abstract class AccountState {}

class AccountInitial extends AccountState {}



//currency loading
class CurrencyLoading extends AccountState{}
class CurrencyGetSuccess extends AccountState {
  List<CurrencyData> currencies;
  CurrencyGetSuccess({required this.currencies});
}
class CurrencyGetFailed extends AccountState {
  String error;
  CurrencyGetFailed({required this.error});
}

//language loading
class LanguageLoading extends AccountState{}
class LanguageGetSuccess extends AccountState {
  List<CurrencyData> currencies;
  LanguageGetSuccess({required this.currencies});
}
class LanguageGetFailed extends AccountState {
  String error;
  LanguageGetFailed({required this.error});
}


class ProfileLoading extends AccountState{}
class ProfileSuccess extends AccountState {
  UserDetail? userDetail;
  ProfileSuccess(this.userDetail);
}
class ProfileFailed extends AccountState {
  String error;
  ProfileFailed({required this.error});
}