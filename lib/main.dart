import 'package:flutter/material.dart';
import 'package:otp/otp.dart';
import 'package:provider/provider.dart';
import 'package:testprojectbc/models/notifyModel.dart';
import 'package:testprojectbc/page/Navbar/HomeNav.dart';
import 'package:testprojectbc/page/Navbar/ProfileNav.dart';
import 'package:testprojectbc/page/Navbar/ReservationNav.dart';
import 'package:testprojectbc/page/Navbar/ChangeEmailScreen.dart';
import 'package:testprojectbc/page/Setting/Theme.dart';

import 'package:testprojectbc/page/Setting/detailNotify.dart';
import 'package:testprojectbc/page/Setting/notify.dart';
import 'package:testprojectbc/page/Setting/notifyService.dart';
import 'package:testprojectbc/page/addPost.dart';
import 'package:testprojectbc/page/authenticator.dart';
import 'package:testprojectbc/page/confirm.dart';
import 'package:testprojectbc/page/curTest.dart';
import 'package:testprojectbc/page/curinfo.dart';
import 'package:testprojectbc/page/currency.dart';
import 'package:testprojectbc/page/emailFA.dart';
import 'package:testprojectbc/page/googleFA.dart';
import 'package:testprojectbc/page/login.dart';
import 'package:testprojectbc/page/Navbar/loginsuccess.dart';
import 'package:testprojectbc/page/otpsuccess.dart';
import 'package:testprojectbc/page/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:testprojectbc/page/screenOTP.dart';
import 'package:testprojectbc/page/smsFA.dart';
import 'package:testprojectbc/page/Setting/notifyService.dart';
import 'page/selectCurency.dart';
import 'page/Setting/makePin.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase Messaging Background Handler

  // Firebase Messaging Initialisation
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
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
              "notify-page": (context) => notify(
                    notification:
                        NotificationModel(amount: '', fromCurrency: ''),
                  ),
              "detailNotify-page": (context) => DetailNotifyPage(),
              "reservaionsNav-page": (context) => ReservationNav(),
              "HomeNav": (context) => const HomeNav(),
              "ProfileNav": (context) => ProfileNav(),
              "changeEmailNav": (context) => changeEmailNav(),
            },
          );
        },
      ),
    );
  }
}
