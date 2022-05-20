import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app/routes/constants.dart';
import 'package:get/get.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:location/location.dart';

class SearchBar extends GetxController {
  // Future getData(String collection) async {
  //   QuerySnapshot snapshot = makerRef.get() as QuerySnapshot<Object?>;
  //   print('getDATA');
  //   return snapshot;
  // }

  Future queryData(String queryString) async {
    Location location = new Location();

    LocationData _locationData;

    _locationData = await location.getLocation();
    final coordinates =
        new Coordinates(_locationData.latitude, _locationData.longitude);
    var address =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);

    print(address.first.locality);

    List<dynamic> list = [];
    QueryDocumentSnapshot queryList;
    print(queryString);
    var temp = makerRef
        .where("name",
            isGreaterThanOrEqualTo: queryString,
            isLessThan: queryString + '\uf7ff')
        .where('city', isEqualTo: address.first.locality)
        .get();
    print(temp.toString());
    return temp;
  }
}
