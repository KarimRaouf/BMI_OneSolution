import 'package:bmi/core/utils/strings.dart';
import 'package:bmi/repos/home/home_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/app_util.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial()) {

    setupBmiStream();


    itemsScrollController.addListener(() {
      if (itemsScrollController.position.pixels ==
          itemsScrollController.position.maxScrollExtent) {
        if (currentPage == 0) {
          ++currentPage;
        }
        setupBmiStream();

        loadMoreItems();
      }

    });

  }

  static HomeCubit get(context) => BlocProvider.of(context);

  final formKey = GlobalKey<FormState>();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  ScrollController itemsScrollController = ScrollController();

  bool validateBMIForm() => formKey.currentState!.validate();

  String status = '';

  String calculateBMIStatus({
    required int height,
    required int weight,
    required int age,
  }) {
    double bmi = weight / ((height / 100) * (height / 100));
    if (bmi < 18.5) {
      status = 'Underweight';
    } else if (bmi >= 18.5 && bmi <= 24.9) {
      status = 'Normal';
    } else if (bmi >= 25 && bmi <= 29.9) {
      status = 'Overweight';
    } else if (bmi >= 30) {
      status = 'Obesity';
    }
    return status;
  }

  Future<void> saveBMIDataInCollection({
    required BuildContext context,
    required String collectionName,
    required Map<String, dynamic> data,
  }) async {
    HomeRepository.saveInCollection(
      context: context,
      collectionName: collectionName,
      data: data,
    ).then((value) {
      // loadMoreData();

      AppUtil.showSnackBar(context: context, content: status);
    }).catchError((error) {});
  }

  DocumentSnapshot? _lastDocument;
  bool _hasMoreData = true;

  bool firstTime = true;

  void setupBmiStream() {

    var query = FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('bmiCalculations')
        .orderBy('createdAt', descending: true);

    query.snapshots().listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
        var newItems =
        snapshot.docs.where((doc) => !bmiItems.contains(doc)).toList();

        bmiItems = newItems;



        print(bmiItems.length);
        if(firstTime){
          loadMoreItems();
          firstTime = false;
        }
        // loadMoreItems();



      }
    });
  }

  final int itemsPerPage = 10;
  int currentPage = 0;

  var displayedItems = [];

  void loadMoreItems() {
    emit(HomeItemsLoading());

    int startIndex = currentPage * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;

    print(startIndex);
    print('startIndex');
    print(bmiItems.length);
    print('bmiItems');
    if (startIndex < bmiItems.length) {


      print(startIndex);


      var newItems = bmiItems
          .getRange(
        startIndex,
        endIndex > bmiItems.length ? bmiItems.length : endIndex,
      )
          .toList();

      displayedItems.addAll(newItems);

      // added recent
      currentPage++;

      print(
          '${displayedItems.length} displayed-=-----------------------------');
      print('${startIndex} displayed-=-----------------------------');

      emit(HomeItemsSuccess()); // Assuming you pass the items to the state

    }
  }

  List<DocumentSnapshot> bmiItems = [];

  // void loadMoreData() async {
  //   emit(HomeItemsLoading());
  //   fetchBMICalculations().then((value) {
  //     List<QueryDocumentSnapshot> newItems = value;
  //     print(value);
  //     bmiItems.addAll(newItems);
  //
  //   });
  //   print(bmiItems.length);
  //
  // }

  void refreshData() {
    _lastDocument = null; // Reset pagination
    bmiItems.clear(); // Clear existing items
  }


  Future<void> updateItem({
    required String uid,
    required String age,
    required String height,
    required String status,
    required String weight,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uId).collection('bmiCalculations').doc(uid).update({
        'age': age,
        'height': height,
        'status': status,
        'weight': weight,
      });
      print("Book successfully updated!");
    } catch (e) {
      print("Error updating book: $e");
    }
  }


  Future<void> deleteItem(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uId).collection('bmiCalculations').doc(documentId)
          .delete();

      emit(state);
      print('Document successfully deleted!');
    } catch (e) {
      print('Error while deleting document: $e');
    }
  }

}
