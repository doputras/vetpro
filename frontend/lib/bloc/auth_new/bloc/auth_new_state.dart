part of 'auth_new_bloc.dart';

@freezed
class AuthNewState with _$AuthNewState {
  const factory AuthNewState.initial() = _Initial;
  const factory AuthNewState.loading() = _Loading;
  const factory AuthNewState.loginUser(UserModel userModel) = _LoginUser;
  const factory AuthNewState.registerUser(UserModel userModel) = _RegisterUser;
  const factory AuthNewState.error(String message) = _Error;
}
