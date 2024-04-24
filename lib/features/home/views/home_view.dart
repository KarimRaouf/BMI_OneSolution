import 'package:bmi/core/shared/widgets/custom_textfield.dart';
import 'package:bmi/core/utils/app_ui.dart';
import 'package:bmi/core/utils/app_util.dart';
import 'package:bmi/core/utils/styles.dart';
import 'package:bmi/generated/assets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/shared/cache_helper.dart';
import '../../../core/shared/widgets/custom_button.dart';
import '../../../core/utils/strings.dart';
import '../view_model/home_cubit.dart';
import '../view_model/home_states.dart';
import 'bmi_form.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        HomeCubit homeCubit = HomeCubit.get(context);
        return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(uId)
                .collection('bmiCalculations')
                .snapshots(),
            builder: (context, snapshot) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    'BMI Calculations',
                    style: Styles.textStyle24
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {
                          CacheHelper.logOut(context);
                        },
                        icon: Icon(Icons.logout)),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    AppUtil.mainNavigator(context, const BMIForm());
                  },
                  backgroundColor: AppUI.navyBlue,
                  child: const Icon(
                    Icons.add,
                    color: AppUI
                        .whiteColor, // Using a predefined icon from Flutter's material icons library
                  ),
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        controller: homeCubit.itemsScrollController,
                        separatorBuilder: (context, index) => Container(
                          width: AppUtil.responsiveWidth(context) - 32,
                          height: 0.5,
                          color: AppUI.blackColor,
                        ),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                                'BMI: ${snapshot.data!.docs[index]['status'].toString()}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Age: ${(snapshot.data!.docs[index]['age'])}',
                                ),
                                Text(
                                  'Height: ${(snapshot.data!.docs[index]['height'])}',
                                ),
                                Text(
                                  'Weight: ${(snapshot.data!.docs[index]['weight'])}',
                                ),
                                Text(
                                    'Date: ${(snapshot.data!.docs[index]['createdAt'] as Timestamp).toDate()}'),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        homeCubit.deleteItem(
                                            snapshot.data!.docs[index].id);
                                      },
                                      icon: Icon(Icons.delete_outlined),
                                    ),
                                    IconButton(
                                      onPressed: () {

                                        AppUtil.mainNavigator(context, BMIForm());
                                      },
                                      icon: Icon(Icons.edit_outlined),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            });
      },
    );
  }
}
