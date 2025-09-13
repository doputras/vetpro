import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vetpro/common/constants/global_variables.dart';
import 'package:vetpro/data/models/user_model.dart';
import 'package:http/http.dart' as http;
// class FirebasAuthDatasource {
//   FirebaseAuth auth = FirebaseAuth.instance;

//   Future<Either<String, UserCredential>> login(
//       String email, String password) async {
//     try {
//       UserCredential credential = await auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return Right(credential);
//     } on FirebaseAuthException catch (e) {
//       return Left(e.toString());
//     }
//   }

//   Future<Either<String, String>> logout() async {
//     try {
//       auth.signOut();
//       return const Right('logout success');
//     } on FirebaseAuthException catch (e) {
//       return Left(e.toString());
//     }
//   }
// }

///=================Gunakan Ini jika menggunakan Api===================

class AuthRemoteDatasource {
  Future<Either<String, UserModel>> login(UserData model) async {
    try {
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };

      final response = await http.post(
        Uri.parse('${GlobalVariables.baseUrl}api/login'),
        headers: headers,
        body: json.encode(model.toJson()),
      );

      if (response.statusCode == 200) {
        return Right(UserModel.fromRawJson(response.body));
      } else {
        return left('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      return left('An exception occurred: $e');
    }
  }

  Future<Either<String, UserModel>> register(UserData model) async {
    try {
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };

      final response = await http.post(
        Uri.parse('${GlobalVariables.baseUrl}api/register'),
        headers: headers,
        body: json.encode(model.toJson()),
      );

      if (response.statusCode == 201) {
        return Right(UserModel.fromRawJson(response.body));
      } else {
        final errorResponse = json.decode(response.body);
        return left(
            'Request failed with status: ${response.statusCode}. Errors: ${errorResponse['errors']}');
      }
    } catch (e) {
      return left('An exception occurred: $e');
    }
  }
}
