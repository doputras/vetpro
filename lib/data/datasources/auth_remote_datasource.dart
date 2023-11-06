import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebasAuthDatasource {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<Either<String, UserCredential>> login(
      String email, String password) async {
    try {
      UserCredential credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(credential);
    } on FirebaseAuthException catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> logout() async {
    try {
      auth.signOut();
      return const Right('logout success');
    } on FirebaseAuthException catch (e) {
      return Left(e.toString());
    }
  }
}

///=================Gunakan Ini jika menggunakan Api===================

// class AutRemoteDatasource {
//   Future<Either<String, AuthResponseModel>> login(
//       AuthRequestModel model) async {
//     var headers = {
//       'Accept': 'application/json',
//       'Content-Type': 'application/json'
//     };
//     final response = await http.post(
//       Uri.parse('${Variables.baseUrl}/api/login'),
//       headers: headers,
//       body: model.toJson(),
//     );

//     if (response.statusCode == 200) {
//       return Right(AuthResponseModel.fromJson(response.body));
//     } else {
//       final errMessage = jsonDecode(response.body);
//       return Left(
//           //'Email and password are not available or are not the same. Check again!'
//           errMessage['message']);
//     }
//   }
// }