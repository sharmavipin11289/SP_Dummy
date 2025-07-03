// Define the states for the login feature.
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  LoginSuccess();
}

class LoginFailure extends LoginState {
  final String error;
  List<dynamic>? extra;
  LoginFailure(this.error, {this.extra = null });
}