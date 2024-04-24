import 'package:bmi/core/utils/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../core/shared/cache_helper.dart';
import '../../core/utils/app_util.dart';

class HomeRepository {
  static Future<void> saveInCollection({
    required BuildContext context,
    required String collectionName,
    required Map<String, dynamic> data,
  }) async {
    CollectionReference collectionReference =
    FirebaseFirestore.instance.collection(collectionName).doc(uId).collection('bmiCalculations');
    collectionReference.add(data).then((value) {
      // AppUtil.showSnackBar(context: context, content: 'Success add data');
      Navigator.pop(context);

    }).catchError((error) {
      AppUtil.showSnackBar(context: context, content: 'Failed to add data');
      print("Failed to add data: $error");
    });
  }
}
