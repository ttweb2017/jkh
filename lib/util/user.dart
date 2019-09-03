import 'package:halkbank_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserUtil {
  static const String LOGIN = "LOGIN";
  static const String USER_ID = "USER_ID";
  static const String FULL_NAME = "FULL_NAME";
  static const String XML_ID = "XML_ID";
  static const String STREET = "STREET";
  static const String HOUSE = "HOUSE";
  static const String FLAT = "FLAT";
  static const String PHPSESSID = "PHPSESSID";
  static const String BX_USER_ID = "BX_USER_ID";
  static const String BITRIX_SM_LOGIN = "BITRIX_SM_LOGIN";
  static const String BITRIX_SM_UIDH = "BITRIX_SM_UIDH";
  static const String SESSID = "SESSID";
  static const String COOKIE = "COOKIE";

  //Method to get Header cookie value from shared pref file
  static Future<Map<String, String>> getUserData() async {
    Map<String, String> data;
    final prefs = await SharedPreferences.getInstance();

    data = {
      LOGIN : prefs.getString(LOGIN),
      USER_ID : prefs.getString(USER_ID),
      FULL_NAME : prefs.getString(FULL_NAME),
      XML_ID : prefs.getString(XML_ID),
      STREET : prefs.getString(STREET),
      HOUSE : prefs.getString(HOUSE),
      FLAT : prefs.getString(FLAT),
      PHPSESSID : prefs.getString(PHPSESSID),
      BX_USER_ID : prefs.getString(BX_USER_ID),
      BITRIX_SM_LOGIN : prefs.getString(LOGIN),
      BITRIX_SM_UIDH : prefs.getString(BITRIX_SM_UIDH),
      SESSID : prefs.getString(SESSID),
      COOKIE : prefs.getString(COOKIE)
    };

    return data;
  }

  //Method to save user data
  static saveUserData(User user) async {

    // obtain shared preferences
    final prefs = await SharedPreferences.getInstance();

    final String cookie = "PHPSESSID=" + user.sessionId + "; BX_USER_ID=" + user.hashedUserId+ "; " +
        "BITRIX_SM_LOGIN=" + user.login + "; BITRIX_SM_SOUND_LOGIN_PLAYED=Y;" +
        " BITRIX_SM_UIDH=" + user.bitrixUidh+ "; BITRIX_SM_UIDL=" + user.login + ";";

    // set value
    prefs.setString(LOGIN, user.login);
    prefs.setString(USER_ID, user.userId);
    prefs.setString(BX_USER_ID, user.hashedUserId);
    prefs.setString(BITRIX_SM_UIDH , user.bitrixUidh);
    prefs.setString(PHPSESSID, user.sessionId);
    prefs.setString(SESSID, user.bitrixSessid);
    prefs.setString(FULL_NAME, user.fullName);
    prefs.setString(XML_ID, user.xmlId);
    prefs.setString(STREET, user.street);
    prefs.setString(HOUSE, user.house);
    prefs.setString(FLAT, user.flat);
    prefs.setString(COOKIE, cookie);

  }

  //Method to clear shared pref
  static clearUserData() async {
    // obtain shared preferences
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();
  }
}