import 'dart:convert';

import 'package:client/core/theme/constants/server.dart';
import 'package:client/core/theme/failure/failure.dart';
import 'package:client/features/auth/model/user_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository (ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  Future<Either<AppFailure,UserModel>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
        final response = await http.post(
          Uri.parse(
          '${ServerConstant.serverURL}/auth/signup',
          ),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(
          {
            'name': name,
            'email': email,
            'password': password,
          },
      ),
    );
    final resBodyMap =  jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 201) {
      // handled error
      return Left(AppFailure(resBodyMap['detail']));
    }

    return Right(
      UserModel.fromMap(resBodyMap)
      );
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }


  Future<Either<AppFailure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
        final response = await http.post(
          Uri.parse(
          '${ServerConstant.serverURL}/auth/login'
          ),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'email': email,
            'password': password,
          },
        ),
      );
      // convert json to map
      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        // handled error
        return Left(AppFailure(resBodyMap['detail']));
      }

      return Right(
        // convert map to UserModel
        UserModel.fromMap(resBodyMap['user']).
        // copy token to UserModel, change token  
        copyWith(
          token: resBodyMap['token'],
        ),
      );
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

    Future<Either<AppFailure, UserModel>> getCurrentUserData(String token) async {
    try {
        final response = await http.get(
          Uri.parse(
          '${ServerConstant.serverURL}/auth/'
          ),
          headers: {
            'Content-Type': 'application/json',
            'x-auth-token': token,
          },
        );
      // convert json to map
      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        // handled error
        return Left(AppFailure(resBodyMap['detail']));
      }

      return Right(
        // convert map to UserModel
        UserModel.fromMap(resBodyMap).
        // copy token to UserModel, change token  
        copyWith(
          token: token,
        ),
      );
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}