import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:townteam_app/common/errors/exceptions.dart';
import 'package:townteam_app/common/errors/failures.dart';
import 'package:townteam_app/common/models/user_model.dart';
import 'package:townteam_app/common/services/firebase_auth_service.dart';
import 'package:townteam_app/features/auth/domain/entites/user_entity.dart';
import 'package:townteam_app/features/auth/domain/repos/auth_repo.dart';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class AuthRepoImplementation extends AuthRepo {
  final FirebaseAuthService firebaseAuthService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthRepoImplementation({required this.firebaseAuthService});

  Future<void> _storeUserData(firebase_auth.User user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'name': user.displayName ?? '',
        'email': user.email,
        'uid': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      log('Error storing user data: $e');
    }
  }

  @override
  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword(
      // String name,
      // String surname,
      String email,
      String password,
      String confirmPassword) async {
    try {
      var user = await firebaseAuthService.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
        confirmPassword: confirmPassword,
      );
      
      await _storeUserData(user);
      
      return right(
        UserModel.fromFirebaseUser(user),
      );
    } on CustomException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      log('Exception in firebaseAuthService.createUserWithEmailAndPassword:${e.toString()}');
      return left(
        ServerFailure(
          'An error occured. Please try again later.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      var user = await firebaseAuthService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      await _storeUserData(user);
      
      return right(
        UserModel.fromFirebaseUser(user),
      );
    } on CustomException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      log('Exception in firebaseAuthService.signInWithEmailAndPassword:${e.toString()}');
      return left(
        ServerFailure(
          'An error occured. Please try again later.',
        ),
      );
    }
  }
}
