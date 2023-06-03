import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testprojectbc/Service/provider/reservationData.dart';
import 'package:testprojectbc/page/Navbar/HomeNav.dart';
import 'package:testprojectbc/page/Navbar/ProfileNav.dart';
import 'package:testprojectbc/page/Navbar/ReservationNav.dart';
import 'package:testprojectbc/page/Reservation/detailAgency.dart';
import 'package:testprojectbc/page/Reservation/detailCur.dart';
import 'package:testprojectbc/page/Reservation/genQR.dart';
import 'package:testprojectbc/page/Reservation/reservaServices.dart';
import 'package:testprojectbc/page/Setting/Theme.dart';
import 'package:testprojectbc/page/Setting/detailNotify.dart';
import 'package:testprojectbc/page/Setting/notify.dart';
import 'package:testprojectbc/page/addPost.dart';
import 'package:testprojectbc/page/authenticator.dart';
import 'package:testprojectbc/page/confirm.dart';
import 'package:testprojectbc/page/curTest.dart';
import 'package:testprojectbc/page/curinfo.dart';
import 'package:testprojectbc/page/currency.dart';
import 'package:testprojectbc/page/emailFA.dart';
import 'package:testprojectbc/page/googleFA.dart';
import 'package:testprojectbc/page/Navbar/loginsuccess.dart';
import 'package:testprojectbc/page/login.dart';
import 'package:testprojectbc/page/otpsuccess.dart';
import 'package:testprojectbc/page/register.dart';
import 'package:testprojectbc/page/smsFA.dart';
import 'package:testprojectbc/role/admin/nav/checkKYC.dart';
import 'package:testprojectbc/role/admin/nav/homeAdmin.dart';
import 'package:testprojectbc/role/admin/nav/navHelperAdmin.dart';
import 'package:testprojectbc/role/agency/nav/checkReservation.dart';
import 'package:testprojectbc/role/agency/nav/homeAgency.dart';
import 'package:testprojectbc/role/agency/nav/navHelper.dart';
import 'package:testprojectbc/screen/testBlockchain.dart';
import 'page/selectCurency.dart';
import 'page/Setting/makePin.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  AwesomeNotifications().initialize(
    //'resource://drawable/res_notification_app_icon',
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        defaultColor: Colors.teal,
        importance: NotificationImportance.High,
        channelShowBadge: true,
      ),
      NotificationChannel(
        channelKey: 'scheduled_channel',
        channelName: 'Scheduled Notifications',
        defaultColor: Colors.teal,
        locked: true,
        importance: NotificationImportance.High,
        soundSource: 'resource://raw/res_custom_notification',
      ),
    ],
  );
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp();
  // Firebase Messaging Background Handler
  // Firebase Messaging Initialisation
  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<ReservationData>(
      create: (context) =>
          ReservationData(), //id: 0, title: '', description: ''
    ),
    ChangeNotifierProvider<NotesServices>(
      create: (context) => NotesServices(),
    ),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  // final NotificationModel notification;
  // const notify({required this.notification});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
    // createReservationPositiveNotification(context);
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget? child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: Styles.themeData(themeChangeProvider.darkTheme, context),
            home: LoginPage(),
            routes: {
              "/register-page": (context) => RegisterPage(),
              "/confirm-page": (context) => ConfirmPage(),
              "/authenticator-page": (context) => AuthenticatorPage(),
              "/loginsuccess-page": (context) => LoginSuccessPage(),
              "/smsfa-page": (context) => SmsPage(),
              "/emailfa-page": (context) => EmailFAPage(),
              "googlefa-page": (context) => GooglefaPage(),
              "otpsuccess-page": (context) => OtpSuccessPage(),
              "addpost-page": (context) => AddpostPage(),
              "currency-page1": (context) => CurrencyPage(),
              "currinfo-page2": (context) => CurInfo(),
              "currinfo-test": (context) => CurTest(),
              "selectCurency-page": (context) => SelectCur(),
              "makePing-page": (context) => CreatePinPage(),
              // "notify-page": (context) => notify(
              //       notification:
              //           NotificationModel(amount: '', fromCurrency: ''),
              //     ),
              "notify-page": (context) => notify(),
              "detailNotify-page": (context) => DetailNotifyPage(),
              "reservaionsNav-page": (context) => ReservationNav(),
              "HomeNav": (context) => HomeNav(),
              "ProfileNav": (context) => ProfileNav(),
              "DetailCur": (context) => DetailCur(),
              "DetailAgency": (context) => DetailAgency(),
              "QRCode-Page": (context) => QRCodePage(),
              "testBC-Page": (context) => testBC(),
              "NavHelper-Page": (context) => NavHleperAgencyPage(),
              "HomeAgency-Page": (context) => HomeAgencyPage(),
              "CheckReservation-Page": (context) => CheckReservationPage(),
              "NavHelperAdmin-Page": (context) => NavHleperAdminPage(),
              "HomeAdmin-Page": (context) => HomeAdminPage(),
              "CheckKYC-Page": (context) => CheckKYCPage(),
            },
          );
        },
      ),
    );
  }
}
