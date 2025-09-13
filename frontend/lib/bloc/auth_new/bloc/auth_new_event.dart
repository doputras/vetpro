part of 'auth_new_bloc.dart';

@freezed
class AuthNewEvent with _$AuthNewEvent {
  const factory AuthNewEvent.started() = _Started;
  const factory AuthNewEvent.login(UserData userData) = _Login;
  const factory AuthNewEvent.register(UserData userData) = _Register;
}
