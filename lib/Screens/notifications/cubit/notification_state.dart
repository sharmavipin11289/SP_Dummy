import 'package:sanaa/Screens/notifications/model/notification_model.dart';

import '../../../CommonFiles/Model/meta_model.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}


class NotificationLoading extends NotificationState {}

class NotificationFailed extends NotificationState {
  String error;
  NotificationFailed({required this.error});
}

class NotificationSuccess extends NotificationState {
  List<NotificationData>notifications;
  Meta? meta;
  NotificationSuccess({required this.notifications, required this.meta});
}