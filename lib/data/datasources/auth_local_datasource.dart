import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDatasource {
  Future<bool> saveAuthData(UserCredential data) async {
    final data = FirebaseAuth.instance;
    final pref = await SharedPreferences.getInstance();
    final result = await pref.setString('auth', data.currentUser.toString());
    return result;
  }

  Future<bool> islogin() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final authJson = pref.getString('auth') ?? '';
    return authJson.isNotEmpty;
  }

  Future<bool> removeAuthData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final result = await pref.remove('auth');
    return result;
  }
}
