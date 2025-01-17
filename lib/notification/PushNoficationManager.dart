import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

class PushNotificationManager {
  static final PushNotificationManager _instance =
      PushNotificationManager._internal();

  factory PushNotificationManager() => _instance;

  PushNotificationManager._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    try {
      await _ensureFirebaseInitialized();

      await _requestNotificationPermissions();

      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      await _initLocalNotifications();

      _foregroundMessageListener();

      _onMessageOpenedAppListener();

      _listenTokenRefresh();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[PushNotificationManager.init] ${e.toString()}');
      }
    }
  }

  Future<String?> getToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      if (kDebugMode) {
        debugPrint('[PushNotificationManager] Current FCM Token: $token');
      }
      return token;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[PushNotificationManager] Error while fetching token: $e');
      }
      return null;
    }
  }

  Future<void> removeToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      if (kDebugMode) {
        debugPrint('[PushNotificationManager] FCM token deleted');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[PushNotificationManager] Error while deleting token: $e');
      }
    }
  }

  void _listenTokenRefresh() {
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      if (kDebugMode) {
        debugPrint('[PushNotificationManager] FCM Token refreshed: $newToken');
      }
    });
  }

  void _foregroundMessageListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      try {
        if (kDebugMode) {
          debugPrint(
              '[PushNotificationManager] Foreground message: ${message.data}');
        }

        final notification = message.notification;
        if (notification != null) {
          await _showLocalNotification(
              title: notification.title,
              body: notification.body,
              hashCode: notification.hashCode);
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint(
              '[PushNotificationManager._foregroundMessageListener] ${e.toString()}');
        }
      }
    });
  }

  void _onMessageOpenedAppListener() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      try {
        if (kDebugMode) {
          print(
              '[PushNotificationManager] onMessageOpenedApp: ${message.data}');
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint(
              '[PushNotificationManager._onMessageOpenedAppListener] ${e.toString()}');
        }
      }
    });
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    try {
      if (kDebugMode) {
        debugPrint(
            '[PushNotificationManager] Background message: ${message.messageId}, data: ${message.data}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
            '[PushNotificationManager._firebaseMessagingBackgroundHandler] ${e.toString()}');
      }
    }
  }

  Future<void> _initLocalNotifications() async {
    try {
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const initSettings = InitializationSettings(
        android: androidSettings,
      );

      await flutterLocalNotificationsPlugin.initialize(
        initSettings,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
            '[PushNotificationManager._initLocalNotifications] ${e.toString()}');
      }
    }
  }

  Future<void> _showLocalNotification(
      {required String? title,
      required String? body,
      required int hashCode}) async {
    try {
      const androidChannel = AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
      );

      const iosNotificationDetails = DarwinNotificationDetails();

      const platformChannelSpecifics = NotificationDetails(
        android: androidChannel,
        iOS: iosNotificationDetails,
      );

      await _localNotificationsPlugin.show(
        hashCode,
        title ?? 'No title',
        body ?? 'No body',
        platformChannelSpecifics,
        payload: 'SomePayload',
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
            '[PushNotificationManager._showLocalNotification] ${e.toString()}');
      }
    }
  }

  Future<void> _requestNotificationPermissions() async {
    try {
      // iOS
      if (Platform.isIOS) {
        NotificationSettings settings =
            await _firebaseMessaging.requestPermission(
          alert: true,
          badge: true,
          sound: true,
          provisional: false,
        );

        await _firebaseMessaging.setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);

        if (kDebugMode) {
          debugPrint(
              '[PushNotificationManager] iOS notification permission status: ${settings.authorizationStatus}');
        }
      } else {
        final NotificationSettings settings =
            await _firebaseMessaging.requestPermission();

        const AndroidNotificationChannel channel = AndroidNotificationChannel(
          'high_importance_channel',
          'High Importance Notifications',
          importance: Importance.max,
        );

        _localNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(channel);

        final deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

        if (androidInfo.version.sdkInt >= 33) {
          _localNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.requestNotificationsPermission();
        }

        if (kDebugMode) {
          debugPrint(
              '[PushNotificationManager] Android notification permission status: ${settings.authorizationStatus}');
        }

        switch (settings.authorizationStatus) {
          case AuthorizationStatus.authorized:
            final fcmToken = await _firebaseMessaging.getToken();

            if (kDebugMode) {
              debugPrint('fcmToken authorized ${fcmToken.toString()}');
            }

            break;

          case AuthorizationStatus.notDetermined:
            final fcmToken = await _firebaseMessaging.getToken();

            if (kDebugMode) {
              debugPrint('fcmToken notDetermined ${fcmToken.toString()}');
            }

            break;

          case AuthorizationStatus.provisional:
            final fcmToken = await _firebaseMessaging.getToken();

            if (kDebugMode) {
              debugPrint('fcmToken provisional ${fcmToken.toString()}');
            }

            break;

          default:
            break;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
            '[PushNotificationManager._requestNotificationPermissions] ${e.toString()}');
      }
    }
  }

  Future<void> _ensureFirebaseInitialized() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
        if (kDebugMode) {
          debugPrint('[PushNotificationManager] Firebase initialized');
        }
      } else {
        if (kDebugMode) {
          debugPrint(
              '[PushNotificationManager] Firebase was already initialized');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[PushNotificationManager] Error initializing Firebase: $e');
      }
    }
  }
}
