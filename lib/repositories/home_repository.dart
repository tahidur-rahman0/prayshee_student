import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:online_training_template/app/const/const.dart';
import 'package:online_training_template/app/core/failure/failure.dart';
import 'package:online_training_template/models/course_model.dart';
import 'package:online_training_template/models/teacher_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  return HomeRepository();
}

class HomeRepository {
  Future<Either<AppFailure, TeacherModel>> getTeacherDetails({
    required String token,
    required int teacherId,
  }) async {
    try {
      print('${ServerConstant.serverURL}/myteacher/$teacherId');
      final res = await http.get(
          Uri.parse('${ServerConstant.serverURL}/myteacher/$teacherId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          });
      var resBodyMap = jsonDecode(res.body);
      print(resBodyMap);
      if (res.statusCode != 200) {
        return Left(AppFailure(resBodyMap['errors']));
      }
      final userData = resBodyMap['data'];

      // Ensure token is added to UserModel
      final user = TeacherModel.fromMap(userData);
      print(user.id);
      return Right(user);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<CourseModel>>> getCourses({
    required String token,
    required int teacherId,
    String? subject,
  }) async {
    try {
      print('${ServerConstant.serverURL}/course');
      print(teacherId);
      print(subject);
      final res = await http.post(
        Uri.parse('${ServerConstant.serverURL}/course'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(
          {
            'teacher_id': teacherId,
            'subject': subject,
          },
        ),
      );
      var resBodyMap = jsonDecode(res.body);
      print(resBodyMap);
      if (res.statusCode != 200) {
        return Left(AppFailure(resBodyMap['errors']));
      }

      // Handle empty data case
      if (resBodyMap['data'] == null || resBodyMap['data'].isEmpty) {
        return Right([]);
      }

      List<CourseModel> course = [];
      final dataList = resBodyMap['data'] as List;

      for (final map in dataList) {
        course.add(CourseModel.fromMap(map));
      }

      return Right(course);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
