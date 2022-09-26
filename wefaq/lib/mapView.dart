import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'bottom_bar_custom.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    getMarkers();

    super.initState();
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(44.427963, -110.588455),
    zoom: 14.4746,
  );

  final _firestore = FirebaseFirestore.instance;
  List<Marker> markers = [];

  //get markers
  Future getMarkers() async {
    await for (var snapshot in _firestore.collection('projects2').snapshots())
      for (var project in snapshot.docs) {
        setState(() {
          markers.add(new Marker(
            markerId: MarkerId(project['name']),
            position: new LatLng(project['lat'], project['lng']),
            infoWindow: InfoWindow(title: project['name']),
          ));
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Upcoming projects", style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 145, 124, 178),
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentHomeScreen: 1,
        updatePage: () {},
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        markers: markers.toSet(),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        initialCameraPosition: _kGooglePlex,
      ),
    );
  }
}
