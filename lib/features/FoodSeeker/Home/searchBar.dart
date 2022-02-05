import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app/routes/constants.dart';
import 'package:get/get.dart';

class SearchBar extends GetxController {
  Future getData(String collection) async {
    QuerySnapshot snapshot = makerRef.get() as QuerySnapshot<Object?>;
    return snapshot;
  }

  Future queryData(String queryString) async {
    print('inside queryData');
    List<dynamic> list = [];
    QueryDocumentSnapshot queryList;
    print(queryString);
    var temp = makerRef
        .where("name",
            isGreaterThanOrEqualTo: queryString,
            isLessThan: queryString + '\uf7ff')
        .get();
    print(temp.toString());
    return temp;
  }
}
