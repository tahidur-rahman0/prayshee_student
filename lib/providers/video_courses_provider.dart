import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:online_training_template/app/core/failure/failure.dart';
import 'package:online_training_template/models/video_model.dart';
import 'package:online_training_template/repositories/home_repository.dart';

final videosListProvider = FutureProvider.family<
    Either<AppFailure, List<VideoModel>>,
    ({String token, int courseId})>((ref, params) async {
  final repo = ref.watch(homeRepositoryProvider);
  return await repo.getVideoMaterials(
    token: params.token,
    courseId: params.courseId,
  );
});
