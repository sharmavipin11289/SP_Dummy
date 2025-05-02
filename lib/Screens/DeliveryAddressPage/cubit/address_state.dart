// Define the states for the login feature.
import 'package:sanaa/CommonFiles/common_api_response.dart';
import 'package:sanaa/Screens/DeliveryAddressPage/Model/address_model.dart';

import '../../SignUpPage/Model/country_model.dart';
import '../Model/city_model.dart';
import '../Model/state_model.dart';

abstract class AddressState {}

class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

class AddressSuccess extends AddressState {
  List<AddressData> response;
  AddressSuccess(this.response);
}

class AddAddressSuccess extends AddressState {}


class AddressFailure extends AddressState {
  final String error;
  AddressFailure(this.error);
}




class ACountryLoadedSuccess extends AddressState {
  List<CountryData> countries;
  ACountryLoadedSuccess(this.countries);
}

class ACountryLoadedFailed extends AddressState {
  final String error;
  ACountryLoadedFailed(this.error);
}




class StateLoadedSuccess extends AddressState {
  List<StateData> states;
  StateLoadedSuccess(this.states);
}

class StateLoadedFailed extends AddressState {
  final String error;
  StateLoadedFailed(this.error);
}



class CityLoadedSuccess extends AddressState {
  List<CityData> cities;
  CityLoadedSuccess(this.cities);
}

class CityLoadedFailed extends AddressState {
  final String error;
  CityLoadedFailed(this.error);
}