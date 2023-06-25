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
  keepCur = context.watch<ReservationData>().notifyCur.toString();
  keepRate = context.watch<ReservationData>().notifyRate.toString();
  keepResevaProviRateUpdate =
      context.watch<ReservationData>().resevaProviRateUpdate.toString();
  final usersRefD1 = FirebaseFirestore.instance.collection('usersPIN');
  final snapshot = await usersRefD1.doc(user).get();
  final Keepdata1 = snapshot.data() as Map<String, dynamic>?;

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'basic_channel',
      title: '${Emojis.money_dollar_banknote}$keepCur Price Alert!',
      body:
          '1 $keepCur is now $keepRate THB ${Emojis.symbols_check_mark} better than' +
              ' ${Keepdata1?['RateNoti']} THB',
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
  keepCur = context.watch<ReservationData>().notifyCur.toString();
  keepRate = context.watch<ReservationData>().notifyRate.toString();
  keepResevaProviRateUpdate =
      context.watch<ReservationData>().resevaProviRateUpdate.toString();
  final usersRefD1 = FirebaseFirestore.instance.collection('usersPIN');
  final snapshot = await usersRefD1.doc(user).get();
  final Keepdata1 = snapshot.data() as Map<String, dynamic>?;
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'basic_channel',
      title: '${Emojis.money_dollar_banknote}$keepCur Price Alert!',
      body:
          '1 $keepCur is now $keepRate THB ${Emojis.icon_anger_symbol} worse than' +
              ' ${Keepdata1?['RateNoti']} THB',
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



