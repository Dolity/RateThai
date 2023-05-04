import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    Color textColor = isDarkTheme ? Colors.white : Colors.black;
    Color cardColor = isDarkTheme
        ? Colors.black //Color.fromARGB(0, 70, 65, 65)
        : Colors.white; // nvrbar ด้านบน

    return ThemeData(
      primarySwatch: Colors.blue, // color defult
      primaryColor: isDarkTheme ? Colors.pink : Colors.white,
      indicatorColor: isDarkTheme ? Colors.black54 : Colors.white,
      buttonColor: isDarkTheme ? Colors.black54 : Colors.white,
      hintColor: isDarkTheme ? Colors.white : Colors.black54,
      highlightColor: isDarkTheme ? Colors.black54 : Colors.white,
      hoverColor: isDarkTheme ? Colors.green : Colors.white,
      focusColor: isDarkTheme ? Colors.green : Colors.white,
      disabledColor: Colors.grey,
      cardColor: cardColor,
      canvasColor: isDarkTheme
          ? Color.fromARGB(255, 70, 65, 65)
          : Colors.grey[50], // change color blackgrund
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
            colorScheme: isDarkTheme
                ? const ColorScheme.dark(
                    primary: Colors.green,
                    onPrimary: Colors.black,
                  )
                : const ColorScheme.light(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                  ),
          ),
      appBarTheme: const AppBarTheme(
        elevation: 3.0,
      ),
      textSelectionTheme: TextSelectionThemeData(
          selectionColor: isDarkTheme ? Colors.greenAccent : Colors.green),
      textTheme: TextTheme(
        bodyText1: TextStyle(
          color: textColor,
        ),
        bodyText2: TextStyle(
          color: textColor,
        ),
        subtitle1: TextStyle(
          color: textColor,
        ),
        subtitle2: TextStyle(
          color: textColor,
        ),
        headline1: TextStyle(
          color: textColor,
        ),
        headline2: TextStyle(
          color: textColor,
        ),
        headline3: TextStyle(
          color: textColor,
        ),
        headline4: TextStyle(
          color: textColor,
        ),
        headline5: TextStyle(
          color: textColor,
        ),
        headline6: TextStyle(
          color: textColor,
        ),
      ),
      cardTheme: CardTheme(
        color: cardColor,
        shadowColor: isDarkTheme ? Colors.white30 : Colors.black45,
        elevation: 100.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.0),
        ),
        margin: const EdgeInsets.all(3.0),
      ),
    );
  }
}

class DarkThemePreference {
  static const THEME_STATUS = "THEMESTATUS";

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_STATUS, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_STATUS) ?? false;
  }
}

class DarkThemeProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
}
