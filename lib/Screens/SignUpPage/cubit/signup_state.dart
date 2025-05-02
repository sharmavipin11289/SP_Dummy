// Define the states for the login feature.
import 'package:sanaa/CommonFiles/common_api_response.dart';
import 'package:sanaa/Screens/SignUpPage/Model/country_model.dart';

abstract class SignupState {}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {}

class SignupFailure extends SignupState {
  final String error;
  SignupFailure(this.error);
}



class CountryLoading extends SignupState {}

class CountryLoadedSuccess extends SignupState {
  List<CountryData> countries;
  CountryLoadedSuccess(this.countries);
}

class CountryLoadedFailed extends SignupState {
  final String error;
  CountryLoadedFailed(this.error);
}


class GoogleLoginLoading extends SignupState {}

class GoogleLoginSuccess extends SignupState {
  CommonResponse response;
  GoogleLoginSuccess({required this.response});
}

class GoogleLoginFailed extends SignupState {
  final String error;
  GoogleLoginFailed(this.error);
}
