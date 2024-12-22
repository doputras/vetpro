import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vetpro/data/datasources/auth_remote_datasource.dart';
import 'package:vetpro/data/models/user_model.dart';

part 'auth_new_event.dart';
part 'auth_new_state.dart';
part 'auth_new_bloc.freezed.dart';

class AuthNewBloc extends Bloc<AuthNewEvent, AuthNewState> {
  final AuthRemoteDatasource datasource;
  AuthNewBloc(this.datasource) : super(_Initial()) {
    on<_Login>(_onLogin);
    on<_Register>(_onRegister);
  }

  FutureOr<void> _onRegister(
      _Register event, Emitter<AuthNewState> emit) async {
    final response = await datasource.register(event.useData);

    response.fold(
      (errorMessage) => emit(AuthNewState.error(errorMessage)),
      (data) {
        if (data.success == true) {
          final responeData = data;
          emit(AuthNewState.registerUser(responeData));
        } else {
          emit(const AuthNewState.error("Gagal Register"));
        }
      },
    );
  }

  FutureOr<void> _onLogin(_Login event, Emitter<AuthNewState> emit) async {
    final response = await datasource.login(event.useData);

    response.fold(
      (errorMessage) => emit(AuthNewState.error(errorMessage)),
      (data) {
        if (data.success == true) {
          final responeData = data;
          emit(AuthNewState.loginUser(responeData));
        } else {
          emit(const AuthNewState.error("Gagal Register"));
        }
      },
    );
  }
}
