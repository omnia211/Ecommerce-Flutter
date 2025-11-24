import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/app_user.dart';


class FirebaseUserService {
  FirebaseUserService._();

  static final FirebaseUserService instance = FirebaseUserService._();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // collection path
  static const String collectionPath = 'users';

  // 🟢 إضافة بيانات المستخدم
  Future<void> addUserData(AppUser user) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(user.uid)
          .set(user.toJson());
    } on FirebaseException catch (e) {
      throw e.message ?? 'Failed to add user data';
    }
  }

  // 🟡 تحميل بيانات المستخدم
  Future<AppUser?> loadUserData(String uid) async {
    try {
      final snapshot =
      await _firestore.collection(collectionPath).doc(uid).get();

      if (!snapshot.exists) return null;

      final data = snapshot.data();
      if (data == null) return null;

      return AppUser.fromJson(data);
    } catch (e) {
      throw 'Failed to load user data: $e';
    }
  }

  // 🔵 تعديل بيانات المستخدم
  Future<void> updateUserData(AppUser user) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(user.uid)
          .update(user.toJson());
    } on FirebaseException catch (e) {
      throw e.message ?? 'Failed to update user data';
    }
  }
}
