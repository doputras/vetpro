import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetpro/data/models/user_model.dart';

class AuthLocalDatasource {
  Future<void> saveAuthData(UserData data) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('role', data.role ?? 'user');
    await pref.setString('id', "${data.id}" ?? '');
    setLogin(true);
  }

  Future<void> setLogin(bool isLoggedIn) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool('isLoggedIn', isLoggedIn);
  }

  Future<bool> getLogin() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool('isLoggedIn') ?? false;
  }

  Future<bool> removeAuthData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final result = await pref.remove('auth');
    return result;
  }

  Future<String?> getRole() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('role');
  }

  Future<String?> getId() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('id');
  }

  Future<void> logout() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove('role');
    await pref.remove('id');
    await setLogin(false);
  }
}
