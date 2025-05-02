// login_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanaa/ApiServices/api_service.dart';
import 'package:sanaa/CommonFiles/common_api_response.dart';
import '../../../CommonFiles/common_variables.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final endPoint = 'auth/signin/request';

  // Method to handle user signup
  Future<void> loginUser({required Map<String,dynamic> param}) async {
    emit(LoginLoading()); // Emit loading state
      try {
        final response = await ApiService().request(endpoint: endPoint, method: 'post',body: param, fromJson: (json) => CommonResponse.fromJson(json));
        print(response.message);
        emit(LoginSuccess());
      } catch (e) {
        emit(LoginFailure('$e'));
      }
  }
}