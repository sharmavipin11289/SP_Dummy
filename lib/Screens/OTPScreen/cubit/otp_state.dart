// Define the states for the login feature.
import 'package:sanaa/CommonFiles/common_api_response.dart';

abstract class OTPState {}

class OTPInitial extends OTPState {}

class OTPLoading extends OTPState {}

class OTPSuccess extends OTPState {}

class LoginOTPSuccess extends OTPState {
  CommonResponse response;
  LoginOTPSuccess(this.response);
}

class OTPToForgotPswdSuccess extends OTPState {
  String resetToken;
  OTPToForgotPswdSuccess(this.resetToken);
}

class OTPSendSuccess extends OTPState {}

class OTPFailure extends OTPState {
  final String error;
  OTPFailure(this.error);
}