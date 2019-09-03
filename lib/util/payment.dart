import 'package:shared_preferences/shared_preferences.dart';

class PaymentUtil {
  static const String SIGN = "SIGN";
  static const String ORDER_ID = "ORDER_ID";
  static const String ORIG_ORDER = "ORIG_ORDER";

  //Method to get payment data from shared pref file
  static Future<Map<String, String>> getPaymentData() async {
    Map<String, String> data;
    final prefs = await SharedPreferences.getInstance();

    data = {
      SIGN : prefs.getString(SIGN),
      ORDER_ID : prefs.getString(ORDER_ID),
      ORIG_ORDER : prefs.getString(ORIG_ORDER)
    };

    return data;
  }

  //Method to set payment data from shared pref file
  static Future<Null> setPaymentData(Map<String, String> data) async {

    final prefs = await SharedPreferences.getInstance();

    prefs.setString(SIGN, data[SIGN]);
    prefs.setString(ORDER_ID, data[ORDER_ID]);
    prefs.setString(ORIG_ORDER, data[ORIG_ORDER]);
  }

  //Method to clear shared pref
  static Future<Null> clearPaymentData() async {
    // obtain shared preferences
    final prefs = await SharedPreferences.getInstance();

    prefs.remove(SIGN);
    prefs.remove(ORDER_ID);
    prefs.remove(ORIG_ORDER);
  }
}