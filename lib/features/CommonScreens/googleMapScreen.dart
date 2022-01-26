import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreen extends StatefulWidget {
  final double lat, long;
  GoogleMapScreen(this.lat, this.long);
  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  String finalAddress = '';

  @override
  void initState() {
    getMarkers(widget.lat, widget.long);
    getAddress(widget.lat, widget.long);
    super.initState();
  }

  getAddress(double latitude, double longitude) async {
    final coordinates = new Coordinates(latitude, longitude);
    var address =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      finalAddress = address.first.addressLine!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Location'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            width: double.infinity,
            child: GoogleMap(
              myLocationEnabled: true,
              onTap: (tapped) async {
                getMarkers(tapped.latitude, tapped.longitude);
                getAddress(tapped.latitude, tapped.longitude);
              },
              onMapCreated: (GoogleMapController controller) {},
              markers: Set<Marker>.of(_markers.values),
              initialCameraPosition: CameraPosition(
                  target: LatLng(widget.lat, widget.long), zoom: 15),
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Address: ' + finalAddress,
                  textAlign: TextAlign.center,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Confirm'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  getMarkers(double lat, double long) {
    MarkerId markerId = MarkerId(lat.toString() + long.toString());
    Marker marker = Marker(
      markerId: markerId,
      position: LatLng(lat, long),
    );
    setState(() {
      _markers.clear();
      _markers[markerId] = marker;
    });
  }
}
