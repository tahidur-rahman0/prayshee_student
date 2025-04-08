import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:online_training_template/app/const/const.dart';
import 'package:online_training_template/app/core/failure/failure.dart';
import 'package:online_training_template/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(AuthRemoteRepositoryRef ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  Future<Either<AppFailure, UserModel>> signup({
    required String name,
    required String phone,
    required int teacherId,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      print('${ServerConstant.serverURL}/students/register');
      final response = await http.post(
        Uri.parse('${ServerConstant.serverURL}/students/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'phone': phone,
          'teacher_id': teacherId,
          'password': password,
          'password_confirmation': confirmPassword,
        }),
      );

      print(response.statusCode);
      print(response.body);

      final resBodyMap = jsonDecode(response.body);

      // Print to debug
      print("Full Response: $resBodyMap");

      if (response.statusCode != 201) {
        return Left(AppFailure(resBodyMap['errors'] ?? 'Something went wrong'));
      }

      // Extract token
      final String token = resBodyMap['token'] ?? '';

      // Extract user data
      final userData = resBodyMap['student'];

      // Ensure token is added to UserModel
      final user = UserModel.fromMap(userData).copyWith(token: token);

      return Right(user);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> login({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${ServerConstant.serverURL}/students/login',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            'login': phone,
            'password': password,
          },
        ),
      );
      final resBodyMap = jsonDecode(response.body);

      print("Full Response: $resBodyMap");

      if (response.statusCode != 200) {
        return Left(AppFailure(resBodyMap['errors'] ?? 'Something went wrong'));
      }

      // Extract token
      final String token = resBodyMap['token'] ?? '';

      // Extract user data
      final userData = resBodyMap['student'];

      // Ensure token is added to UserModel
      final user = UserModel.fromMap(userData).copyWith(token: token);

      return Right(user);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> getCurrentUserData(String token) async {
    try {
      print('${ServerConstant.serverURL}/student');
      final response = await http.get(
        Uri.parse(
          '${ServerConstant.serverURL}/student',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final resBodyMap = jsonDecode(response.body);

      print("Full Response: $resBodyMap");

      if (response.statusCode != 200) {
        return Left(AppFailure(resBodyMap['errors'] ?? 'Something went wrong'));
      }

      // Extract token
      final String getToken = token;

      // Extract user data
      final userData = resBodyMap['data'];

      // Ensure token is added to UserModel
      final user = UserModel.fromMap(userData).copyWith(token: getToken);

      return Right(user);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
