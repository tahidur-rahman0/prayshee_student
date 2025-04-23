import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:online_training_template/app/core/failure/failure.dart';
import 'package:online_training_template/models/transaction_model.dart';
import 'package:online_training_template/repositories/transaction_repository.dart';

final myCourseListProvider = FutureProvider.family<
    Either<AppFailure, List<TransactionModel>>,
    ({String token, int studentId})>((ref, params) async {
  final repo = ref.watch(transactionRepositoryProvider);
  return await repo.getMyCourses(
    token: params.token,
    studentId: params.studentId,
  );
});
