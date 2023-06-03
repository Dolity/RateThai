import 'package:flutter/material.dart';

class ReservationData with ChangeNotifier {
  String resevaFromCur = "";
  String resevaToCur = "";
  String resevaAgency = "";
  String resevaAmount = "";
  String resevaRateMoney = "";
  String resevaAgen_Rate = "";

  String resevaProviRateUpdate = ""; // High Rate!
  String resevaProviAgencyUpdate = "";

  String notifyCur = ""; // set for test notify as set value
  String notifyRate = "";

  notifyChange() {
    notifyListeners();
  }
}
