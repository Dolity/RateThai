// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService {
//   static FlutterLocalNotificationsPlugin _notificationsPlugin;

//   static void init() {
//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: AndroidInitializationSettings('@mipmap/ic_launcher'),
//       iOS: IOSInitializationSettings(),
//     );

//     _notificationsPlugin = FlutterLocalNotificationsPlugin();
//     _notificationsPlugin.initialize(initializationSettings);
//   }

//   static Future<void> showNotification({
//     String title,
//     String body,
//   }) async {
//     final AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//       'channelId',
//       'channelName',
//       'channelDescription',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     final NotificationDetails platformDetails =
//         NotificationDetails(android: androidDetails);

//     await _notificationsPlugin.show(
//       0,
//       title,
//       body,
//       platformDetails,
//     );
//   }
// }
