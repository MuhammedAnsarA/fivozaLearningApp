import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fivoza_learning/core/enums/update_user.dart';
import 'package:fivoza_learning/core/errors/exception.dart';
import 'package:fivoza_learning/core/utils/constants.dart';
import 'package:fivoza_learning/core/utils/typedef.dart';
import 'package:fivoza_learning/features/auth/data/models/user_model.dart';
import 'package:flutter/foundation.dart';

abstract class AuthRemoteDataSource {
  const AuthRemoteDataSource();

  Future<void> forgotPassword(String email);

  Future<LocalUserModel> signIn({
    required String email,
    required String password,
  });

  Future<void> signUp({
    required String email,
    required String fullName,
    required String password,
  });

  Future<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _authClient;
  final FirebaseFirestore _cloudStoreClient;
  final FirebaseStorage _dbClient;

  AuthRemoteDataSourceImpl({
    required FirebaseAuth authClient,
    required FirebaseFirestore cloudStoreClient,
    required FirebaseStorage dbClient,
  })  : _authClient = authClient,
        _cloudStoreClient = cloudStoreClient,
        _dbClient = dbClient;

  /* -------------------------- forgotPassword -------------------------- */

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _authClient.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? "Error Occured",
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: "505");
    }
  }

  /* -------------------------- signIn -------------------------- */

  @override
  Future<LocalUserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _authClient.signInWithEmailAndPassword(
          email: email, password: password);

      final user = result.user;
      if (user == null) {
        const ServerException(
            message: "Please try again later", statusCode: "Unknown Error");
      }
      var userData = await _getUserData(user!.uid);
      if (userData.exists) {
        return LocalUserModel.fromMap(userData.data()!);
      }

      await _setUserData(user, email);
      userData = await _getUserData(user.uid);
      return LocalUserModel.fromMap(userData.data()!);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? "Error Occured",
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: "505");
    }
  }

  /* -------------------------- signUp -------------------------- */

  @override
  Future<void> signUp({
    required String email,
    required String fullName,
    required String password,
  }) async {
    try {
      final userCred = await _authClient.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCred.user?.updateDisplayName(fullName);
      await userCred.user?.updatePhotoURL(kDefaultAvatar);
      await _setUserData(_authClient.currentUser!, email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? "Error Occured",
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: "505");
    }
  }

  /* -------------------------- updateUser -------------------------- */

  @override
  Future<void> updateUser({
    required UpdateUserAction action,
    dynamic userData,
  }) async {
    try {
      switch (action) {
        case UpdateUserAction.email:
          await _authClient.currentUser
              ?.verifyBeforeUpdateEmail(userData as String);
          await _updateUserData({"email": userData});

        case UpdateUserAction.displayName:
          await _authClient.currentUser?.updateDisplayName(userData as String);
          await _updateUserData({"fullName": userData});

        case UpdateUserAction.profilePic:
          final ref = _dbClient
              .ref()
              .child("profile_pics/${_authClient.currentUser?.uid}");
          await ref.putFile(userData as File);
          final url = await ref.getDownloadURL();
          await _authClient.currentUser?.updatePhotoURL(url);
          await _updateUserData({"profilePic": url});
        case UpdateUserAction.password:
          if (_authClient.currentUser?.email == null) {
            throw const ServerException(
                message: "User does not exist",
                statusCode: "Insufficiant Permission");
          }
          final newData = jsonDecode(userData as String) as DataMap;
          await _authClient.currentUser?.reauthenticateWithCredential(
            EmailAuthProvider.credential(
              email: _authClient.currentUser!.email!,
              password: newData["oldPassword"] as String,
            ),
          );
          await _authClient.currentUser?.updatePassword(
            newData["newPassword"] as String,
          );

        case UpdateUserAction.bio:
          await _updateUserData({"bio": userData as String});
      }
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? "Error Occured",
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: "505");
    }
  }

  /* -------------------------- _getUserData -------------------------- */

  Future<DocumentSnapshot<DataMap>> _getUserData(String uid) async {
    return _cloudStoreClient.collection("users").doc(uid).get();
  }

  /* -------------------------- _setUserData -------------------------- */

  Future<void> _setUserData(User user, String fallbackEmail) async {
    await _cloudStoreClient.collection("users").doc(user.uid).set(
          LocalUserModel(
            uid: user.uid,
            email: user.email ?? fallbackEmail,
            points: 0,
            fullName: user.displayName ?? "",
            profilePic: user.photoURL ?? "",
          ).toMap(),
        );
  }

  /* -------------------------- _updateUserData -------------------------- */

  Future<void> _updateUserData(DataMap data) async {
    await _cloudStoreClient
        .collection("users")
        .doc(_authClient.currentUser?.uid)
        .update(data);
  }
}
