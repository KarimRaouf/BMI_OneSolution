import 'package:bmi/repos/auth/auth_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/shared/cache_helper.dart';
import 'auth_state.dart';
import 'model/user_model.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of(context);

  Future<void> signInAnonymous({
    required BuildContext context,
  }) async {
    emit(LoginLoadingState());

    await AuthRepository.signInAnonymous(context: context).then((value) {
      // CacheHelper.saveData(
      //   key: 'uId',
      //   value: userCredential.user!.uid,
      // );
      emit(LoginSuccessState());
    }).catchError((error) {
      emit(LoginErrorState(error));
    });
  }

// void userRegister({
//   required String email,
//   required String password,
//   required String name,
//   required String phone,
// }) {
//   emit(AuthRegisterLoading());
//   FirebaseAuth.instance
//       .createUserWithEmailAndPassword(
//     email: email,
//     password: password,
//   )
//       .then((value) {
//     print(value.user!.email);
//     print(value.user!.uid);
//     createUser(
//       email: email,
//       name: name,
//       phone: phone,
//       uId: value.user!.uid,
//     );
//   }).catchError((error) {
//     print(error);
//     emit(AuthRegisterError(errorMessage: error.toString()));
//   });
// }
//
// void createUser({
//   required String email,
//   required String name,
//   required String phone,
//   required String uId,
// }) {
//   SocialUserModel model = SocialUserModel(
//     name: name,
//     email: email,
//     phone: phone,
//     uId: uId,
//     image:
//         'https://img.freepik.com/free-photo/young-man-student-with-notebooks-showing-thumb-up-approval-smiling-satisfied-blue-studio-background_1258-65597.jpg?w=1060&t=st=1670074506~exp=1670075106~hmac=d48a0f4855cc77ba746481cdedb3a670f029ca5d57696c574d3ef7366acd126f',
//     cover:
//         'https://img.freepik.com/free-photo/full-shot-travel-concept-with-landmarks_23-2149153258.jpg?3&w=1380&t=st=1670165859~exp=1670166459~hmac=2bb6b17d891786e4a3fcfcd043972956c498a8af8881f0d29e341fbfe35d9ee1',
//     bio: 'write your bio ..',
//     isEmailVerified: false,
//   );
//
//   FirebaseFirestore.instance
//       .collection('users')
//       .doc(uId)
//       .set(model.toMap())
//       .then((value) {
//     emit(CreateUserSuccessState(uId));
//   }).catchError((error) {
//     emit(CreateUserErrorState(error.toString()));
//   });
// }
//
// // }
// //
// // IconData suffix = Icons.visibility_outlined;
// //
// // bool isPasswordShown = true;
// //
// // void changePasswordVisibility() {
// //   isPasswordShown = !isPasswordShown;
// //   suffix = isPasswordShown
// //       ? Icons.visibility_outlined
// //       : Icons.visibility_off_outlined;
// //   emit(SocialRegisterChangePasswordVisibilityState());
// // }
// //
// //
// void userLogin({required String email, required String password}) {
//   emit(LoginLoadingState());
//   FirebaseAuth.instance
//       .signInWithEmailAndPassword(
//     email: email,
//     password: password,
//   )
//       .then((value) {
//     print(value.user!.email);
//     emit(LoginSuccessState(value.user!.uid));
//   }).catchError((error) {
//     emit(LoginErrorState(error.toString()));
//     print(error);
//   });
// }
}
