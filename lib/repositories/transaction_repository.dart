import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:online_training_template/app/const/const.dart';
import 'package:online_training_template/app/core/failure/failure.dart';
import 'package:online_training_template/models/transaction_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
part 'transaction_repository.g.dart';

@riverpod
TransactionRepository transactionRepository(TransactionRepositoryRef ref) {
  return TransactionRepository();
}

class TransactionRepository {
  Future<Either<AppFailure, TransactionModel>> createTransection(
      {required String token,
      required int teacherId,
      required int studentId,
      required String studentName,
      required int courseId,
      required String courseName,
      required double price,
      required String paymentId,
      required String paymentMode}) async {
    try {
      print('${ServerConstant.serverURL}/create/transaction');
      print(teacherId);
      final res = await http.post(
        Uri.parse('${ServerConstant.serverURL}/create/transaction'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(
          {
            "teacher_id": teacherId,
            "student_id": studentId,
            "student_name": studentName,
            "course_id": courseId,
            "course_name": courseName,
            "price": price,
            "payment_id": paymentId,
            "payment_mode": paymentMode,
            "remark": "Payment request"
          },
        ),
      );
      print(res.statusCode);
      print(res.body);
      var resBodyMap = jsonDecode(res.body);
      if (res.statusCode != 201) {
        return Left(AppFailure(resBodyMap['errors']));
      }
      final userData = resBodyMap['data'];

      // Ensure token is added to UserModel
      final user = TransactionModel.fromMap(userData);
      print(user.id);
      return Right(user);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
