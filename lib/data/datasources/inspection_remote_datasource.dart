import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:vetpro/data/models/inspection_model.dart';

class InspectionRemoteDatasource {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Either<String, InspectionModel>> addInspection(
      InspectionModel data) async {
    try {
      final response = await firestore.collection("inspection").add({
        "result": data.result,
        "animal": data.animal,
        "cage_treatment": data.cageTreatment,
        "environmental_care": data.environmentalCare,
        "feeding": data.feeding,
        "inspector": data.inspector,
        "location": data.location,
        "medical_treatment": data.medicalTreatment,
        "suggestion": data.suggestion,
        "created_at": data.createdAt,
      });
      await firestore
          .collection("inspection")
          .doc(response.id)
          .update({"inspection_id": response.id});

      InspectionModel dataResponse = InspectionModel(
        result: data.result,
        animal: data.animal,
        cageTreatment: data.cageTreatment,
        environmentalCare: data.environmentalCare,
        feeding: data.feeding,
        inspector: data.inspector,
        location: data.location,
        medicalTreatment: data.medicalTreatment,
        suggestion: data.suggestion,
        inspectionId: response.id,
        createdAt: data.createdAt,
      );
      return Right(dataResponse);
    } on FirebaseException catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<InspectionModel>>> getListInspection() async {
    List<InspectionModel> inspectList = [];
    try {
      final response =
          await FirebaseFirestore.instance.collection("inspection").get();

      for (var element in response.docs) {
        Map<String, dynamic> data = element.data();
        inspectList.add(InspectionModel.fromMap(data));
      }

      return Right(inspectList);
    } on FirebaseException catch (e) {
      return Left(e.toString());
    }
  }
}
