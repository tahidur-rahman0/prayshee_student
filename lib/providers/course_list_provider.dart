import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:online_training_template/app/core/failure/failure.dart';
import 'package:online_training_template/models/course_model.dart';
import 'package:online_training_template/repositories/home_repository.dart';

final courseListProvider = FutureProvider.family<
    Either<AppFailure, List<CourseModel>>,
    ({String token, int teacherId, String? subject})>((ref, params) async {
  final repo = ref.watch(homeRepositoryProvider);
  return await repo.getCourses(
    token: params.token,
    teacherId: params.teacherId,
    subject: params.subject ?? null,
  );
});
