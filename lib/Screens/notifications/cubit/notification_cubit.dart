

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanaa/CommonFiles/common_api_response.dart';
import 'package:sanaa/Screens/notifications/cubit/notification_state.dart';
import 'package:sanaa/Screens/notifications/model/notification_model.dart';

import '../../../ApiServices/api_service.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  final _endPoint = 'notification';

  Future<void> getNotifications({required int page}) async {
    print("inside");
    emit(NotificationLoading()); // Emit loading state
    try {
      final response = await ApiService().request(endpoint: _endPoint + '?page=$page', method: 'get', fromJson: (json) => NotificationModel.fromJson(json));
      print(response.message);
      emit(NotificationSuccess(notifications: response.notifications ?? [], meta: response.meta));
    } catch (e) {
      emit(NotificationFailed(error: '$e'));
    }
  }

}