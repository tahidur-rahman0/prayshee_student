import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:online_training_template/app/core/failure/failure.dart';
import 'package:online_training_template/models/teacher_model.dart';
import 'package:online_training_template/repositories/home_repository.dart';

final teacherDetailsProvider = FutureProvider.family<
    Either<AppFailure, TeacherModel>,
    ({String token, int teacherId})>((ref, params) async {
  final repo = ref.watch(homeRepositoryProvider);
  return await repo.getTeacherDetails(
    token: params.token,
    teacherId: params.teacherId,
  );
});
