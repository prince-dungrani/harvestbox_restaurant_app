import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Top-level handler for background FCM messages
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Background message received: ${message.messageId}');
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  // ─── INITIALIZE ───
  Future<void> initialize() async {
    // 1. Local Notifications Setup
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        print('Notification tapped: ${details.payload}');
      },
    );

    // 2. Request Notification Permissions
    await _requestPermissions();

    // 3. Firebase Cloud Messaging Setup
    await _setupFCM();
  }

  // ─── REQUEST PERMISSIONS ───
  Future<void> _requestPermissions() async {
    // FCM permissions (also handles iOS)
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    print('FCM permission status: ${settings.authorizationStatus}');

    // Android 13+ local notification permission
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  // ─── FCM SETUP ───
  Future<void> _setupFCM() async {
    // Get FCM token
    final token = await _fcm.getToken();
    print('FCM Token: $token');

    // Listen for token refresh
    _fcm.onTokenRefresh.listen((newToken) {
      print('FCM Token refreshed: $newToken');
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message: ${message.notification?.title}');
      if (message.notification != null) {
        showNotification(
          title: message.notification!.title ?? 'HarvestBox',
          body: message.notification!.body ?? '',
          payload: message.data.toString(),
        );
      }
    });

    // Handle notification tap when app is in background (not terminated)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message opened app: ${message.data}');
    });

    // Handle notification tap when app was terminated
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      print('App opened from terminated state: ${initialMessage.data}');
    }

    // Register background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  // ─── SHOW LOCAL NOTIFICATION (immediate) ───
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'harvestbox_channel',
      'HarvestBox Notifications',
      channelDescription: 'Order updates and promotions',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecond, // Unique ID
      title,
      body,
      details,
      payload: payload,
    );
  }

  // ─── ORDER PLACED NOTIFICATION ───
  Future<void> showOrderPlacedNotification(String orderId) async {
    await showNotification(
      title: 'Order Confirmed! 🎉',
      body: 'Your order has been placed successfully. We\'re preparing it now!',
      payload: 'order_$orderId',
    );
  }

  // ─── SCHEDULE REMINDER NOTIFICATION ───
  Future<void> scheduleReminderNotification() async {
    // Show a reminder after 2 hours
    await Future.delayed(const Duration(seconds: 5)); // Demo: 5 seconds
    await showNotification(
      title: 'Hungry? 🍔',
      body: 'Order your favourite meal from HarvestBox!',
      payload: 'reminder',
    );
  }

  // ─── ORDER STATUS UPDATE ───
  Future<void> showOrderStatusNotification(String status) async {
    String title;
    String body;

    switch (status) {
      case 'preparing':
        title = 'Preparing Your Order 👨‍🍳';
        body = 'The chef is preparing your delicious meal!';
        break;
      case 'out_for_delivery':
        title = 'Out for Delivery! 🚗';
        body = 'Your order is out for delivery. Get ready!';
        break;
      case 'delivered':
        title = 'Delivered! ✅';
        body = 'Your order has been delivered. Enjoy your meal!';
        break;
      default:
        title = 'Order Update';
        body = 'Your order status: $status';
    }

    await showNotification(title: title, body: body, payload: 'status_$status');
  }
}
