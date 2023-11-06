// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:vetpro/data/datasources/auth_remote_datasource.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  FirebasAuthDatasource firebasAuthDatasource;
  LoginBloc(
    this.firebasAuthDatasource,
  ) : super(const _Initial()) {
    on<_Login>((event, emit) async {
      emit(const _Loading());
      final response =
          await firebasAuthDatasource.login(event.email, event.password);
      response.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Loaded(r)),
      );
    });
  }
}
