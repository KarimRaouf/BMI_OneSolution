import 'package:bmi/core/utils/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../core/shared/cache_helper.dart';
import '../../core/utils/app_util.dart';

class AuthRepository {
  static Future<User?> signInAnonymous({
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();

      CacheHelper.setSavedString('uId', userCredential.user!.uid);
      uId = userCredential.user!.uid;

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'operation-not-allowed':
          AppUtil.showSnackBar(
              context: context, content: 'operation-not-allowed');

          print('Anonymous auth hasn\'t been enabled for this project.');
          break;
        default:
          AppUtil.showSnackBar(
              context: context, content: 'An undefined Error happened.');
          print('An undefined Error happened.');
      }
      return null;
    } catch (e) {
      AppUtil.showSnackBar(
          context: context,
          content: 'An error occurred using signInAnonymously');
      print('An error occurred using signInAnonymously');
      return null;
    }
  }
}
