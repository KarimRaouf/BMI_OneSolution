import 'package:bmi/core/shared/widgets/custom_button.dart';
import 'package:bmi/core/utils/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/shared/widgets/custom_textfield.dart';
import '../../../core/utils/strings.dart';
import '../view_model/home_cubit.dart';
import '../view_model/home_states.dart';

class BMIForm extends StatefulWidget {
  const BMIForm({super.key, this.isUpdate  = false});

  final bool isUpdate ;
  @override
  State<BMIForm> createState() => _BMIFormState();
}

class _BMIFormState extends State<BMIForm> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        HomeCubit homeCubit = HomeCubit.get(context);
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: homeCubit.formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.BMIFrom,
                        style: Styles.textStyle24
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: homeCubit.ageController,
                        textInputType: TextInputType.number,
                        validation: true,
                        hint: 'Age',
                        height: 80,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: homeCubit.heightController,
                        textInputType: TextInputType.number,
                        validation: true,
                        hint: 'Height',
                        height: 80,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: homeCubit.weightController,
                        textInputType: TextInputType.number,
                        validation: true,
                        hint: 'Weight',
                        height: 80,
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        size: 25,
                        text: AppStrings.submit,
                        onTap: () {


                          if (homeCubit.validateBMIForm()) {
                            String status = homeCubit.calculateBMIStatus(
                              height: int.tryParse(
                                      homeCubit.heightController.text) ??
                                  0,
                              weight: int.tryParse(
                                      homeCubit.weightController.text) ??
                                  0,
                              age: int.tryParse(homeCubit.ageController.text) ??
                                  0,
                            );

                            if(!widget.isUpdate) {
                              homeCubit.saveBMIDataInCollection(
                                context: context,
                                collectionName: 'users',
                                data: {
                                  'height': int.tryParse(
                                      homeCubit.heightController.text),
                                  'weight': int.tryParse(
                                      homeCubit.weightController.text),
                                  'age':
                                  int.tryParse(homeCubit.ageController.text),
                                  'status': status,
                                  'createdAt': FieldValue.serverTimestamp(),
                                },
                              );

                              homeCubit.setupBmiStream();

                            }else{


                              // homeCubit.updateItem(uid: uid, age: age, height: height, status: status, weight: weight)
                            }
                            // homeCubit.refreshData();

                          }
                        },
                        buttomWidth: .9 * MediaQuery.sizeOf(context).width,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // HomeCubit.get(context).ageController.clear();
    // HomeCubit.get(context).heightController.clear();
    // HomeCubit.get(context).weightController.clear();
    // HomeCubit.get(context).ageController.dispose();
    // HomeCubit.get(context).weightController.dispose();
    // HomeCubit.get(context).heightController.dispose();

    super.dispose();

  }
}
