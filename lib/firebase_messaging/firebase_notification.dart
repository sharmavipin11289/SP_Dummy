import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Singleton class to manage Firebase push notifications
class FirebaseNotifications {
  static final FirebaseNotifications _instance = FirebaseNotifications._internal();
  factory FirebaseNotifications() => _instance;
  FirebaseNotifications._internal();

  final FirebaseMessaging _msgService = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Initialize FCM and local notifications
  Future<void> initFCM() async {
    try {
      // Initialize local notifications for foreground
      await _initializeLocalNotifications();

      // Request notification permissions
      NotificationSettings settings = await _msgService.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted notification permission');

        // Handle APNS token for iOS
        if (Platform.isIOS) {
          String? apnsToken;
          // Retry up to 3 times to get APNS token
          for (int i = 0; i < 3; i++) {
            apnsToken = await _msgService.getAPNSToken();
            if (apnsToken != null) {
              print('APNS Token: $apnsToken');
              break;
            } else {
              print('APNS Token not available yet, retrying (${i + 1}/3)...');
              await Future.delayed(Duration(seconds: 1));
            }
          }

          if (apnsToken == null) {
            print('Failed to retrieve APNS token after retries.');
            return; // Exit early to avoid calling getToken() without APNS token
          }

          // Listen for APNS token refresh
          _msgService.onTokenRefresh.listen((newToken) {
            print('New APNS Token: $newToken');
          });
        }

        // Get and print FCM token
        String? token = await _msgService.getToken();
        if (token != null) {
          print('FCM Token: $token');
        } else {
          print('FCM Token not available.');
        }

        // Listen for FCM token refresh
        _msgService.onTokenRefresh.listen((newToken) {
          print('New FCM Token: $newToken');
        });

        // Set up foreground message handler
        FirebaseMessaging.onMessage.listen(_handleNotification);

        // Set up background message handler (use top-level function)
        FirebaseMessaging.onBackgroundMessage(handleNotificationBackgroundMessage);

        // Handle messages when app is opened from a terminated state
        RemoteMessage? initialMessage = await _msgService.getInitialMessage();
        if (initialMessage != null) {
          _handleNotification(initialMessage);
        }

        // Handle messages when app is opened from background
        FirebaseMessaging.onMessageOpenedApp.listen(_handleNotification);
      } else {
        print('User declined or has not granted notification permission');
      }
    } catch (e) {
      print('Error initializing FCM: $e');
    }
  }

  // Initialize flutter_local_notifications for foreground notifications
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('ic_notification');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);
    await _localNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print('Notification tapped: ${response.payload}');
      },
    );

    // Create Android notification channel
    const androidChannel = AndroidNotificationChannel(
      'default_channel',
      'Default Notifications',
      description: 'Channel for default notifications',
      importance: Importance.max,
    );
    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  // Handle notification display and logging
  Future<void> _handleNotification(RemoteMessage message) async {
    print('Notification Message ID: ${message.messageId}');
    print('Notification Data: ${message.data}');

    if (message.notification != null) {
      print('Notification Title: ${message.notification!.title}');
      print('Notification Body: ${message.notification!.body}');

      // Show notification in foreground
      const notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'default_channel',
          'Default Notifications',
          channelDescription: 'Channel for default notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      );
      await _localNotificationsPlugin.show(
        message.messageId.hashCode,
        message.notification?.title ?? 'Notification',
        message.notification?.body ?? 'You have a new message!',
        notificationDetails,
        payload: message.data.toString(),
      );
    } else {
      print('No notification payload present');
    }
  }

  // Retrieve FCM token
  Future<String?> getToken() async {
    try {
      return await _msgService.getToken();
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }
}

// Background message handler (top-level function)
Future<void> handleNotificationBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Background Notification Message ID: ${message.messageId}');
  print('Background Notification Data: ${message.data}');
  if (message.notification != null) {
    print('Background Notification Title: ${message.notification!.title}');
    print('Background Notification Body: ${message.notification!.body}');
  }
}