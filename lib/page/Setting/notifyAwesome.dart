import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testprojectbc/Service/provider/reservationData.dart';
import 'package:testprojectbc/page/Setting/notiDate.dart';

String keepCur = "";
String keepRate = "";
String keepResevaProviRateUpdate = "";

final user = FirebaseAuth.instance.currentUser!.uid;

int createUniqueId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(100000);
}

Future<void> createReservationPositiveNotification(BuildContext context) async {
  final usersRefD1 = FirebaseFirestore.instance.collection('usersPIN');
  final snapshot = await usersRefD1.doc(user).get();

  double previousRate = double.parse(snapshot['RateNoti']); //Rate from User set
  double currentRate =
      double.parse(snapshot['QRCode']['Rate']); //Rate from agency Scarping
  String Curr = snapshot['QRCode']['Currency'];

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'basic_channel',
      title: '${Emojis.money_dollar_banknote}$Curr Price Alert!',
      body:
          '1 $Curr  is now $keepRate THB ${Emojis.symbols_check_mark} better than' +
              ' ${previousRate} THB',
      notificationLayout: NotificationLayout.Default,

      // 1 $keepCur = $keepResevaProviRateUpdate THB
      // bigPicture: 'asset://assets/notification_map.png',
      // notificationLayout: NotificationLayout.BigPicture,
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'MARK_DONE',
        label: 'Mark Done',
      ),
    ],
  );
}

Future<void> createReservationNegativeNotification(BuildContext context) async {
  // keepCur = context.watch<ReservationData>().notifyCur.toString();
  // keepRate = context.watch<ReservationData>().notifyRate.toString();
  // keepResevaProviRateUpdate =
  //     context.watch<ReservationData>().resevaProviRateUpdate.toString();
  final usersRefD1 = FirebaseFirestore.instance.collection('usersPIN');
  final snapshot = await usersRefD1.doc(user).get();
  // final Keepdata1 = snapshot.data() as Map<String, dynamic>?;

  double previousRate = double.parse(snapshot['RateNoti']); //Rate from User set
  double currentRate =
      double.parse(snapshot['QRCode']['Rate']); //Rate from agency Scarping
  String Curr = snapshot['QRCode']['Currency'];

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'basic_channel',
      title: '${Emojis.money_dollar_banknote}$Curr Price Alert!',
      body:
          '1 $Curr is now $currentRate THB ${Emojis.icon_anger_symbol} worse than' +
              ' ${previousRate} THB',
      notificationLayout: NotificationLayout.Default,
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'MARK_DONE',
        label: 'Mark Done',
      ),
    ],
  );
}

Future<void> createReservationReminderNotification(
    NotificationWeekAndTime notificationSchedule) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'scheduled_channel',
      title: '${Emojis.wheater_droplet} Add some water to your plant!',
      body: 'Water your plant regularly to keep it healthy.',
      notificationLayout: NotificationLayout.Default,
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'MARK_DONE',
        label: 'Mark Done',
      ),
    ],
    schedule: NotificationCalendar(
      weekday: notificationSchedule.dayOfTheWeek,
      hour: notificationSchedule.timeOfDay.hour,
      minute: notificationSchedule.timeOfDay.minute,
      second: 0,
      millisecond: 0,
      repeats: true,
    ),
  );
}

Future<void> cancelScheduledNotifications() async {
  await AwesomeNotifications().cancelAllSchedules();
}

////////////////////////////////////////////////////////////////////////////////
// void createNotificationChannelsGPT() {
//   AwesomeNotifications().createNotification(
//     content: NotificationContent(
//       id: 'basic_channel',
//       channelKey: 'basic_channel',
//       channelName: 'Basic Notifications',
//       channelDescription: 'Basic Notification Channel',
//       defaultColor: Colors.teal,
//       ledColor: Colors.teal,
//       playSound: true,
//       vibrationPattern:
//           highVibrationPattern, // เพิ่มการตั้งค่ารูปแบบการสั่นสะเทือน (ถ้าต้องการ)
//       enableVibration: true,
//     ),
//   );
// }

void registerNotificationActionsGPT() {
  AwesomeNotifications().actionStream.listen((notification) {
    // ทำสิ่งที่ต้องการเมื่อมีการทำงานจากการแจ้งเตือน
    if (notification.channelKey == 'basic_channel') {
      // ตรวจสอบว่าเป็นการแจ้งเตือนเบื้องต้นและต้องการให้ปิดแจ้งเตือนบน iOS
      if (Platform.isIOS) {
        AwesomeNotifications().getGlobalBadgeCounter().then((value) {
          AwesomeNotifications().setGlobalBadgeCounter(value - 1);
        });
      }

      // สามารถเปิดหน้าต่างใดก็ได้ที่ต้องการหลังจากคลิกที่การแจ้งเตือน
      // Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(builder: (_) => PlantStatsPage()),
      //   (route) => route.isFirst,
      // );
    }
  });
}

void createReservationPositiveNotificationGPT(BuildContext context) {
  final String title = 'Rate Alert';
  final String body = '1 $keepCur = $keepResevaProviRateUpdate THB';

  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1,
      channelKey: 'basic_channel',
      title: title,
      body: body,
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'allow_button',
        label: 'Allow',
        buttonType: ActionButtonType.Default,
        autoCancel: true,
      ),
      NotificationActionButton(
        key: 'not_allow_button',
        label: 'Not Allow',
        buttonType: ActionButtonType.Default,
        autoCancel: true,
      ),
    ],
  );
}

void createReservationNegativeNotificationGPT(BuildContext context) {
  final String title = 'Rate Alert';
  final String body = '1 $keepCur = $keepResevaProviRateUpdate THB';

  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 2,
      channelKey: 'basic_channel',
      title: title,
      body: body,
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'allow_button',
        label: 'Allow',
        buttonType: ActionButtonType.Default,
        autoCancel: true,
      ),
      NotificationActionButton(
        key: 'not_allow_button',
        label: 'Not Allow',
        buttonType: ActionButtonType.Default,
        autoCancel: true,
      ),
    ],
  );
}





// Future<void> createWaterReminderNotification(
//     NotificationWeekAndTime notificationSchedule) async {
//   await AwesomeNotifications().createNotification(
//     content: NotificationContent(
//       id: createUniqueId(),
//       channelKey: 'scheduled_channel',
//       title: '${Emojis.wheater_droplet} Add some water to your plant!',
//       body: 'Water your plant regularly to keep it healthy.',
//       notificationLayout: NotificationLayout.Default,
//     ),
//     actionButtons: [
//       NotificationActionButton(
//         key: 'MARK_DONE',
//         label: 'Mark Done',
//       ),
//     ],
//     schedule: NotificationCalendar(
//       weekday: notificationSchedule.dayOfTheWeek,
//       hour: notificationSchedule.timeOfDay.hour,
//       minute: notificationSchedule.timeOfDay.minute,
//       second: 0,
//       millisecond: 0,
//       repeats: true,
//     ),
//   );
// }



