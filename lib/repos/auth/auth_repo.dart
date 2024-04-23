import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../core/utils/app_util.dart';

class AuthRepository {
  static Future<User?> signInAnonymous({
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      AppUtil.showSnackBar(context: context, content: e.toString());
      return null;
    }
  }
}
